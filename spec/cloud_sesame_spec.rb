# require 'spec_helper'
# require 'ruby-prof'
# require 'benchmark'

# describe CloudSesame do

# 	# AWS initializer
# 	# =======================================================
# 	require 'yaml'
# 	YAML.load_file('aws.yml').each do |key, value|
# 		ENV["AWS_#{ key }"] = value
# 	end

# 	# Domain Initializer /config/initializers/cloudsearch.rb
# 	# =======================================================
# 	require 'cloud_sesame'

# 	CloudSesame::Domain::Client.configure do |config|
# 		config.access_key = ENV['AWS_ACCESS_KEY_ID']
# 		config.secret_key = ENV['AWS_SECRET_ACCESS_KEY']
# 	end

# 	# Usage Example
# 	# =======================================================
# 	class Product
# 		include CloudSesame

# 		define_cloudsearch do
# 			# Product CloudSesame Config
# 			config.endpoint = ENV['AWS_ENDPOINT']
# 			config.region 	= ENV['AWS_REGION']

# 			default_size 100

# 			define_sloppiness 3

# 			define_fuzziness do
# 				max_fuzziness 3
# 				min_char_size 6
# 				fuzzy_percent 0.17
# 			end

# 			field :searchable_text, 		query: { weight: 2 }
# 			field :description, 				query: true
# 			field :tags

# 			field :affiliate_advertiser_ext_id, facet: { size: 50 }
# 			field :currency, 						facet: true
# 			field :discount_percentage, facet: { buckets: %w([10,100] [25,100] [50,100] [70,100]), method: 'interval' }
# 			field :manufacturer_name, 	facet: { size: 50 }
# 			field :price, 							facet: { buckets: %w([0,25] [25,50] [50,100] [100,200] [200,}), method: 'interval' }
# 			field :category_string, 		facet: { sort: 'bucket', size: 10_000 }
# 			field :created_at,					default: -> { gt Date.today }

# 			scope :shoes_by_brand, ->(brand = nil) { query("shoes").and { manufacturer_name brand }  if brand }
# 			scope :and_mens do
# 				and! { tags "men"}
# 			end

# 		end

# 	end


# 	n = 500
# 	result = RubyProf.profile do
# 	  n.times do
# 			q = Product.cloudsearch.query("black   jacket").sort(price: :asc).page(1).size(1000).and {
# 					or! {
# 						tags "men", "women"
# 						and! {
# 							tags.not "child", "home"
# 						}
# 						and!.not {
# 							tags.start_with "great", "nice"
# 							tags.not.start_with "super"
# 							tags.not.near "hello world"
# 							tags start_with("wifi"), near("electronic")
# 							tags term "cool"
# 							tags phrase "flash_deal"
# 						}
# 						or!.not {
# 							price 25..100
# 							price 100...200
# 							price gte(200).lt(300)
# 							price gte(300)
# 						}
# 						or! {
# 							created_at Date.today - 7
# 							created_at gte(Date.today)
# 							created_at gte(Date.today).lt(Date.today + 3)
# 						}
# 					}
# 				}.compile

# 	  end
# 	end
# 	printer = RubyProf::FlatPrinter.new(result)
# 	printer.print(STDOUT, {})

# 	# q = Product.cloudsearch.and {
# 	# 	binding.pry
# 	# }

# end
