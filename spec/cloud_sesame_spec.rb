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
# 			field :tags, as: :text1

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


# 	@tags = [1, 2]
# 	n = 10_000
#   q = nil
# 	result = RubyProf.profile do
# 	  n.times do
# 			q = Product.cloudsearch.query("black   jacket").sort(price: :asc).page(1).size(1000).and {
# 					or! {
# 					tags *@tags
# 					tags
# 					tags nil
# 					and! {
# 						tags.not "3", "4"
# 					}
# 					and!.not {
# 						tags.start_with "5", "6"
# 						tags.not.start_with("7")
# 						tags.not.near("8", distance: 7)
# 						tags start_with("9"), near("10")
# 						tags term("11", boost: 2)
# 						tags.not phrase "12"
# 					}
# 					or!.not {
# 						price(25..100)
# 						price 100...200
# 						price gte(200).lt(300)
# 						price gte(300)
# 					}
# 					or! {
# 						created_at Date.today - 7
# 						created_at gte(Date.today)
# 						created_at gte(Date.today).lt(Date.today + 3)
# 					}
# 				}
# 			}
# 	# 		q.applied_filters

# 	  end
# 	end
# 	printer = RubyProf::FlatPrinter.new(result)
# 	printer.print(STDOUT, {})

# 	binding.pry

#   # class ProductController

#   #   def load_user
#   #     @name = "scott"
#   #   end

#   #   def greeting
#   #     "hello world!"
#   #   end

#   #   def search
#   #   	load_user
#   #     q = Product.cloudsearch.and {
#   #       binding.pry
#   #     }
#   #   end

#   # end

#   # test = ProductController.new
#   # test.search
# end
