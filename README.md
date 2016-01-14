#CloudSesame
Light and Flexible CloudSearch Query Interface

#Install
In terminal
	```gem install CloudSesame```
In Gemfile
	```gem 'CloudSesame```

#Setup 

2. Initalize the gem 
* Inside the Rails `config/initializers` folder, create a file called `cloud_sesame.rb`
* In the file, enter in your AWS credentials

```
require 'cloud_sesame'
CloudSesame::Domain::Client.configure do |config|
	config.access_key = ENV['AWS_ACCESS_KEY_ID']
	config.secret_key = ENV['AWS_SECRET_ACCESS_KEY']
end
```

3. Setup your searchable model

* `include CloudSesame`
* call `define_cloudsearch` to setup your CloudSearch config, default size (optional), fields, and scopes (optional).

```
class Product
  include CloudSesame  
  
  define_cloudsearch do 
    config.endpoint = ENV[AWS_ENDPOINT]
    config.region = END[AWS_REGION]
    
    default_size 100  #will default to 10 if not defined
    
    field :description, query: true 
    field :name, query: { weight: 2 }
    field :currency, facet: true 
    field :manufacturer, facet: { size: 50 }
    field :price, facet: { buckets: %w([0, 25], [25, 50], [50, 100]), method: 'interval'}
    
    scope :puma_shoes, -> { query("shoes").and { manufacturer "Puma" } } 
    scope :puma_shoes do 
      query("shoes").and { manufacturer "Puma" } 
    end

  end
end
```

4. How to define search fields 
* to add a field to query_options, set `query: true` 
* to add a field to query_options with a weight, set `query: { weight: <any integer> }`
* to add a field to filter_query, set `facet : true`
