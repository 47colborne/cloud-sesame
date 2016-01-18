#CloudSesame
Light and Flexible CloudSearch Query Interface

#Install
* In terminal type:
```
gem install CloudSesame
```
* Or add this line to the application in Gemfile:
```
gem 'CloudSesame
```

#Setup AWS Credentials
*Create a initializer file, example: `config/initializers/cloud_sesame.rb`
```
require 'cloud_sesame'

CloudSesame::Domain::Client.configure do |config|
	config.access_key = ENV['AWS_ACCESS_KEY_ID']
	config.secret_key = ENV['AWS_SECRET_ACCESS_KEY']
end
```
#Usage
##1. Mix CloudSesame into any class or model
```
class Product < ActiveRecord::Base
	include CloudSesame
	
	# call `define_cloudsearch` to setup your CloudSearch config, default size (optional), fields, and scopes (optional)
	define_cloudsearch do 
	
		# REQUIRED: class specific config
		config.endpoint = ENV['AWS_PRODUCT_SEARCH_ENDPOINT']
		config.region 	= ENV['AWS_PRODUCT_SEARCH_REGION']
		
		# default query size is 10
		default_size <integer>
		
		# turn on sloppy query with distance
		define_sloppiness 3
		
		# turn on fuzzy search
		define_fuzziness {
			max_fuzziness <integer> # => maximum fuzziness per word, DEFAULT: 3
			min_char_size <integer>	# => minimum word size to trigger fuzziness, DEFAULT: 6
			fuzzy_percent <float>	# => [(word.size * fuzzy_percent).round, max_fuzziness].min, DEFAULT: 0.17
		}
		
		# field config
		field :product_name,	query: { weight: <integer> }	# => query_options[:fields] = ["product_name^<integer>"]
		field :description,		query: true						# => query_options[:fields] = ["description"]
		
		field :currency,		facet: true				# => enable facet
		field :discount,	 	facet: { 				# => enable facet with buckets
			buckets: %w([10,100] [25,100] [50,100] [70,100]), 
			method: 'interval' 
		}
		field :manufacturer,	facet: { size: 50 }		# => enable facet with max size
		field :category,		facet: { 				# => enable facet with sorting
			sort: 'bucket', size: 10_000 
		}
		
		field :created_at
		
		# scope examples
		
		# INPUT: "puma", 
		# OUPUT: query="shoes", filter_query="(and manufacturer:'puma')"
		scope :shoes_by_brand, ->(brand = nil) { query("shoes").and { manufacturer brand } if brand }
		
		# INPUT: 1
		# OUPUT: filter_query="(and created_at:{'2016-01-17T00:00:00Z',})"
		scope :created_in, ->(days = nil) { and { created_at r.gt(Date.today - days) } if days }
		
	end
end
```
##2. Inheriting from another class or model
```
# Inheriting Definitions from another class
class ExclusiveProduct < Product

	# load previous define cloudsearch definition
	load_definition_from Product
	
	# call define_cloudsearch again to override config 
	# or map field to a different name
	define_cloudsearch {
		field :name, as: :product_name		# => it will use name as product_name's alias, so user can query with
											# NewProduct.cloudsearch.name("shoes") instead of .product_name("shoes")
											# but the output will still be filter_query="product_name:'shoes'"
	}
end
```

##3. Query DSL

###Simple Query
```
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

###Pagination
```
Product.cloudsearch.page(3).size(100)				
# OUTPUT: { start: 200, size: 100 }

Product.cloudsearch.start(99).size(100)				
# OUTPUT: { start: 99, size: 100 }
```

###Sorting
```
Product.cloudsearch.sort(name: :desc)				
# OUTPUT: { sort: "name desc" }

Product.cloudsearch.sort(name: :desc, price: :asc)	
# OUTPUT: { sort: "name desc,price asc" }
```

###Return
```
Product.cloudsearch.all_fields						
# OUTPUT: { return: "_all_fields" }

Product.cloudsearch.no_fields						
# OUTPUT: { return: "_no_fields" }

Product.cloudsearch.score							
# OUTPUT: { return: "_score" }
```

###Scope
```
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

###AND & OR Block
```
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

###Field Methods
```
Product.cloudsearch.name("shoes")				
# OUTPUT: "name:'shoes'"

Product.cloudsearch.name("shoes").price(100)	
# OUTPUT: "(and name:'shoes' price:100)"

Product.cloudsearch.and {						
	name "shoes"
	price 25..100
}					
# OUTPUT: "(and name:'shoes' price:[25,100])"

Product.cloudsearch.and {						
	name.not "shoes"
	...
}
# OUTPUT: "(and (not name:'shoes') ...)"

Product.cloudsearch.and {
	name.start_with "shoes"						
}
# OUTPUT: "(and (prefix field='name' 'shoes'))"

Product.cloudsearch.and {
	name.near "shoes"						
}
# OUTPUT: "(and (near field='name' 'shoes'))"

Product.cloudsearch.and {
	name.not.start_with "shoes"					
}
# OUTPUT: "(and (not (near field='name' 'shoes')))"

Product.cloudsearch.and {
	name start_with("shoes"), near("puma")				
}
# OUTPUT: "(and (near field='name' 'shoes'))"
```

