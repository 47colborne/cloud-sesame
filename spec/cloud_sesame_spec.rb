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


# 	n = 10000
# 	q = nil
# 	result = RubyProf.profile do
# 	  n.times do
# 			q = Product.cloudsearch.query("black   jacket").sort(price: :asc).page(1).size(1000).and {
# 				# tags "1", "2"
# 				# tags.not "3", "4"
# 				# tags.start_with "5"
# 				# tags.near "6"
# 				# tags.not phrase "7"
# 				# tags.not term "8"
# 				# tags.not start_with("9"), near("10")
# 				# tags.start_with phrase("11")
# 				or! {
# 					tags "12", "13"
# 					and! {
# 						tags.not "14", "15"
# 					}
# 					and!.not {
# 						tags.start_with "16", "17"
# 						tags.not.start_with "18"
# 						tags.not.near "19"
# 						tags start_with("20"), near("21")
# 						tags term "22"
# 						tags phrase "23"
# 					}
# 					or!.not {
# 						price 24..25
# 						price 26...27
# 						price gte(28).lt(29)
# 						price gte(30)
# 					}
# 					or! {
# 						created_at Date.today - 7
# 						created_at gte(Date.today)
# 						created_at gte(Date.today).lt(Date.today + 3)
# 					}
# 				}
# 			}
# 			q.compile
# 			fields = q.context[:filter_query][:fields]
# 	  end
# 	end
# 	printer = RubyProf::FlatPrinter.new(result)
# 	printer.print(STDOUT, {})
# 	p q.request.filter_query.compile
# 	# q = Product.cloudsearch.and {
# 		# binding.pry
# 	# }

# end
