# CloudSesame
Powerful and Flexible AWS CloudSearch Query DSL

[![Build Status](https://travis-ci.org/47colborne/cloud-sesame.svg?branch=master)](https://travis-ci.org/47colborne/cloud-sesame)
[![Gem Version](https://badge.fury.io/rb/CloudSesame.svg)](https://badge.fury.io/rb/CloudSesame)
[![Code Climate](https://codeclimate.com/github/47colborne/cloud-sesame/badges/gpa.svg)](https://codeclimate.com/github/47colborne/cloud-sesame)
[![Test Coverage](https://codeclimate.com/github/47colborne/cloud-sesame/badges/coverage.svg)](https://codeclimate.com/github/47colborne/cloud-sesame/coverage)

## Installation
* In terminal type:
```bash
gem install CloudSesame
```
* Or add this line to the application in `Gemfile`:
```ruby
gem 'CloudSesame'
```

## AWS Credentials
* Create a initializer file, example: `config/initializers/cloud_sesame.rb`
```ruby
require 'cloud_sesame'

CloudSesame::Domain::Client.configure do |config|
  config.access_key = ENV['AWS_ACCESS_KEY_ID']
  config.secret_key = ENV['AWS_SECRET_ACCESS_KEY']
end
```

## Model Setup
- `include CloudSesame` in a model or class
- `define_cloudsearch` with a block to setup class/modal specific setting

#### define_cloudsearch(&block)
Includes all Model/Class specific cloudsearch configurations
```ruby
class Product
  include CloudSesame

  define_cloudsearch do 
    ...
  end
end
```

#### config.endpoint=(string)
Set AWS CloudSearch instance search endpoint
#### config.region=(string) 
Set AWS CloudSearch isntance region
```ruby
class Product
  include CloudSesame

  define_cloudsearch do 
    config.endpoint = ENV[...]
    config.region 	= ENV[...]
  end
end
```

#### default_size(integer = 10) 
Set default search size
```ruby
class Product
  include CloudSesame

  define_cloudsearch do 
    default_size 100
  end
end
```

#### define_sloppiness(integer)
Setup sloppy query, it is turned off by default
```ruby
class Product
  include CloudSesame

  define_cloudsearch do 
    define_sloppiness 3
  end
end
```

#### define_fuzziness(&block)
Setup fuzziness, it is turned off by default.
the block can set 3 values 
- **max_fuzziness(integer = 3)**
	maxinmum fuzziness per word
- **min_char_size(integer = 6)**
	minimum word length to trigger fuzziness
- **fuzzy_percent(float = 0.17)**
	percent used to calculate the fuzziness based on the word length, fuzziness whill choose between the calculated result and maximum fizziness, whichever is smaller.
	[(word.size * fuzzy_percent).round, max_fuzziness].min
```ruby
class Product
  include CloudSesame

  define_cloudsearch do 
    define_fuzziness do
      max_fuzziness 3
      min_char_size 6
      fuzzy_percent 0.17
    end
  end
end
```

#### field(symbol, options = {})
calling field and pass in a field_name will create an field expression accessor
- simple usage
```ruby
field :name
```

and field expression accessor can be called to create a field expression
```ruby
Product.cloudsearch.name("user")

{ filter_query: "name:'user'" }
```

- aliased field name 
```ruby
field :text1, as: :name
```

and field expression accessor method name will be `name`
```ruby
Product.cloudsearch.name("user")

{ filter_query: "text1:'user'" }
```

- with query options is set to `true`
```ruby
field :name, query: true			

{ query_options: { fields: ['name'] } }
```

- with **weight** assigned to query options
```ruby
field :tags, query: { weight: 2 }

{ query_options[:fields] = ['name', 'tags^2'] }
```

- with **facet options** passed in
```ruby
field :currency, facet: true

{ facets: { currency:{} } }
```

- with facet **buckets**
```ruby
field :discount, facet: { 				
  buckets: %w([10,100] [25,100] [50,100] [70,100]), 
  method: 'interval' 
}

{ facets: { discount: { buckets:["[10,100]","[25,100]","[50,100]","[70,100]"], method:"interval"} } }
```

- with facet **size** set
```ruby
field :manufacturer, facet: { size: 50 }
```

- with facet **sorting**
```ruby
field :category, facet: { sort: 'bucket', size: 10_000 }	
```

#### scope(symbol, proc, &block)
ActiveRecord styled scope method. Scope allows you to specify commonly-used queries which can be referenced as method calls on cloudsearch or inside of operator block
**set scope**
```ruby
  ...
  define_cloudsearch do 
    ....

    scope :popular, -> { or! { tags "popular"; popularity gt(70) } }
  end
```

**call a scope**
```ruby
Product.cloudsearch.query("shoes").popular
```

### Full Example
```ruby
class Product < ActiveRecord::Base
  include CloudSesame

  define_cloudsearch do 
    config.endpoint = ENV['AWS_PRODUCT_SEARCH_ENDPOINT']
    config.region 	= ENV['AWS_PRODUCT_SEARCH_REGION']

    default_size <integer>

    define_sloppiness <integer>

    define_fuzziness {
      max_fuzziness <integer>
      min_char_size <integer>
      fuzzy_percent <float>
    }

    field :product_name,	query: { weight: <integer> }
    field :description,		query: true

    field :currency,		facet: true		
    field :discount,	 	facet: { 
      buckets: %w([10,100] [25,100] [50,100] [70,100]), 
      method: 'interval' 
    }
    field :manufacturer,	facet: { size: <integer> }
    field :category,		facet: { 
      sort: 'bucket', size: <integer> 
    }

    field :created_at

    scope :shoes_by_brand, ->(brand = nil) { query("shoes").and { manufacturer brand } if brand }

    scope :created_in, ->(days = nil) { and { created_at r.gt(Date.today - days) } if days }
  end
end
```

## Inherit cloudsearch definition from another class/model
#### load_definition_from(Class/Model)
```ruby
class ExclusiveProduct < Product
  load_definition_from Product
end
```
definition can be overrided by calling `#define_cloudsearch` again
```ruby
define_cloudsearch {
  field :name, as: :product_name
}
```

## Query DSL
- `.cloudsearch` returns a CloudSesame::Domain::Base instance. It is the entry point to start building up the query
- A CloudSesame::Query::Builder instance is expected to return from any query methods chained after `.cloudsearch` 
```ruby
Product.cloudsearch #=> <CloudSesame::Domain::Base/>
query = Product.cloudsearch.query("shoes") => <CloudSesame::Query::Builder query:'shoes'/>
```

**Query methods can be chained and build up**
```ruby
query = Product.cloudsearch.query("shoes")
  .and { 
    manufacturer('puma')
    or!.not {
      manufacturer "nike", "adidas"
    }
  }
  .sort(price: :desc)
  .page(2)
  .size(100)
}
```

and `query.compile` will output the compiled hash
```ruby
{
  query:'shoes',
  filter_query: "(and manufacturer:'puma' (not (or manufacturer:'nike' manufacturer:'adidas')))",
  sort: "price desc"
  start: 100
  size: 100
}
```

### Simple Query
```ruby
# Simple Query String
Product.cloudsearch.query("shoes")				
# OUTPUT: "shoes"

Product.cloudsearch.query("shoes -puma")			
# OUTPUT: "shoes -puma"

# With Sloppy Query
Product.cloudsearch.query("shoes")					
# OUTPUT: "(shoes|\"shoes\"~3)"

Product.cloudsearch.query("shoes -puma")			
# OUTPUT: "(shoes -puma|\"shoes -puma\"~3)"

# With Fuzzy Search
Product.cloudsearch.query("white shoes")			
# OUTPUT: "(shoes|(white~3+shoes~3))"

Product.cloudsearch.query("white shoes -puma")		
# OUTPUT: "(shoes -puma|(white~3+shoes~3+-puma))"
```

### Pagination
```ruby
Product.cloudsearch.page(3).size(100)				
# OUTPUT: { start: 200, size: 100 }

Product.cloudsearch.start(99).size(100)				
# OUTPUT: { start: 99, size: 100 }
```

### Sorting
```ruby
Product.cloudsearch.sort(name: :desc)				
# OUTPUT: { sort: "name desc" }

Product.cloudsearch.sort(name: :desc, price: :asc)	
# OUTPUT: { sort: "name desc,price asc" }
```

### Return
```ruby
Product.cloudsearch.all_fields						
# OUTPUT: { return: "_all_fields" }

Product.cloudsearch.no_fields						
# OUTPUT: { return: "_no_fields" }

Product.cloudsearch.score							
# OUTPUT: { return: "_score" }
```

### Scope
```ruby
Product.coudsearch.shoes_by_brand("puma")			
# OUTPUT: { query:"shoes" filter_query:"(and manufacturer:'puma')" }

Product.cloudsearch.created_in(7)					
# OUTPUT: { filter_query:"(and created_at:{Date.today - 7,}) }

Product.cloudsearch.or { 							
  created_in(7)									
  discount 25..100							
}	
# OUTPUT: { filter_query:"(or (and created_at:{Date.today - 7,}) discount:{25,100] }
```

### AND & OR Block
```ruby
Product.cloudsearch.and { ... }					
# OUTPUT: "(and ...)"

Product.cloudsearch.and {						
  or! { ... }									
  or! { ... }									 
}
# OUTPUT: "(and (or ...) (or ...))"
# NOTE: AND & OR are a ruby syntax, can not be used directly,
# so aliased them to (and!, all) and (or!, any)

Product.cloudsearch.and.not { ... }				
# OUTPUT: "(not (and ...))"

Product.cloudsearch.or { and!.not { ...} }		
# OUTPUT: "(or (not (and ...)))"
```

### Field Methods
##### field_name(*values)
- calling the field_name with multiple values will generate multiple field expression
- fields can be chained together

```ruby
Product.cloudsearch.name("shoes")				
# OUTPUT: "name:'shoes'"

Product.cloudsearch.name "shoes", "sneaker"
# OUTPUT: name:'shoes' name:'sneaker'

Product.cloudsearch.name("shoes").price(100)	
# OUTPUT: "(and name:'shoes' price:100)"

Product.cloudsearch.and { name "shoes"; price 25..100 }
# OUTPUT: "(and name:'shoes' price:[25,100])"
```

##### field_name.field_array_method(*values)
- #not, #prefix (#start_with, #begin_with), #near can be called after the field_name
- #not can be chained with another operator after, example: `name.not.prefix`

```ruby
Product.cloudsearch.and { name.not "shoes"; ... }
# OUTPUT: "(and (not name:'shoes') ...)"

Product.cloudsearch.and { name.start_with "shoes" }
# OUTPUT: "(and (prefix field='name' 'shoes'))"

Product.cloudsearch.and { name.near "shoes" }
# OUTPUT: "(and (near field='name' 'shoes'))"

Product.cloudsearch.and { name.not.start_with "shoes" }
# OUTPUT: "(and (not (near field='name' 'shoes')))"

Product.cloudsearch.and { name(start_with("shoes"), near("puma")).not("nike") }
# OUTPUT: "(and (prefix field='name' 'shoes') (near field='name' 'puma') (not name:'nike'))"
```
* #prefix (#start_with, #begin_with), #near can be called directly to generate a single field value

```ruby
Product.cloudsearch.and { name.not start_with("shoes"), near("something") } 
# OUTPUT: "(not (prefix field='name' 'shoes') (not (near field='name' 'something')))"
```

### Date, Time and Rage
* field method accepts Ruby Date and Range Object and will automatically parse them into the CloudSearch format 
```ruby
Date.today	=> "'2016-01-18T00:00:00Z'"
Time.now	=> "'2016-01-18T14:36:57Z'"
25..100 	=> "[25,100]"
25...100	=> "[25,100}"
```

* use #range or #r for more complicated range, range object accepts Date/Time object as well
```ruby
r.gt(100)		=> "{100,}"
r.gte(100)		=> "[100,}"
r.lt(100)		=> "{,100}"
r.lte(100)		=> "{,100]"
r.gte(100).lt(200)	=> "[100,200}"
r.gt(Date.today)	=> "{'2016-01-18T00:00:00Z',}"
```

## Search Related Methods
* `#search`   => send off the request, save and returns the response and clear the request
* `#found`    => returns the hits found from the response 
* `#results`  => returns the hits.hit from the response
* `#each`     => Calls the given block once for each result, passing that result as a parameter. Returns the results itself.
* `#map`      => Creates a new array containing the results returned by the block.
* `#request`  => returns the cloudsearch ast tree
* `#response` => returns the last response
* `#clear_request` => resets the request
* `#clear_reponse` => resets the response

## Other Methods
* `#compile`  => compiles the current query and return the compiled hash
