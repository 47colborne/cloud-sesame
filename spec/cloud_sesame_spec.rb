# require 'spec_helper'

# describe CloudSesame do

# 	# FAKE RAILS AND RAILS CACHE
# 	# =====================================
# 	class ::Rails
# 		def self.cache
# 			@cache ||= FakeCache.new
# 		end
# 	end

# 	class ::FakeCache
# 		def table
# 			@table ||= {}
# 		end
# 		def fetch(key, &block)
# 			table[key] ||= (block.call if block_given?)
# 		end
# 	end

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

# 		def self.greeting
# 			"hello world!"
# 		end

# 		define_cloudsearch do
# 			# Product CloudSesame Config
# 			config.endpoint = ENV['AWS_ENDPOINT']
# 			config.region 	= ENV['AWS_REGION']

#       caching_with :RailsCache

# 			default_size 100

# 			define_sloppiness 3

# 			define_fuzziness do
# 				max_fuzziness 3
# 				min_char_size 6
# 				fuzzy_percent 0.17
# 			end

# 			field :searchable_text, 		query: { weight: 2 }, type: :string
# 			field :description, 				query: true, type: :string
# 			field :tags,								type: :string

# 			field :affiliate_advertiser_ext_id, facet: { size: 50 }
# 			field :currency, 						facet: true
# 			field :discount_percentage, facet: { buckets: %w([10,100] [25,100] [50,100] [70,100]), method: 'interval' }
# 			field :manufacturer_name, 	facet: { size: 50 }
# 			field :price, 							facet: { buckets: %w([0,25] [25,50] [50,100] [100,200] [200,}), method: 'interval' }
# 			field :category_string, 		facet: { sort: 'bucket', size: 10_000 }
# 			field :created_at,					type: :date

# 		end

# 	end

# 	class Coupon
# 	  include CloudSesame

# 	  VALID_COUPON_RANK = 20

# 	  define_cloudsearch do
# 	    config.endpoint = ENV['AWS_ENDPOINT']
# 	    config.region   = ENV['AWS_REGION']

# 	    default_size 10

# 	    define_sloppiness 3

# 	    define_fuzziness do
# 	      max_fuzziness 3
# 	      min_char_size 6
# 	      fuzzy_percent 0.17
# 	    end

# 	    field :end_date,                            as: :date1
# 	    field :rank,                                as: :num1, default: -> { gte VALID_COUPON_RANK }
# 	    field :searchable_text,                     query: true
# 	    field :affiliate_advertiser_search_ext_id,  as: :string1, facet: { size: 50 }
# 	    field :countries,                           as: :string_array1
# 	    field :deal_types,                          as: :string_array2, facet: {}
# 	    field :tags,                                as: :string_array3, facet: {}
# 	    field :type,                                default: -> { 'Catalog::CouponSearchable' }
# 	  end

# 	end

# 	@tags = [1, 2]
# 	q = nil
# 	profile 1 do
# 		q = Product.cloudsearch
# 							.query("black leather jacket")
# 							.sort(price: :asc, created_at: :desc)
# 							.page(3)
# 							.size(1000)
# 							.price { gt 1 }
# 							.tags { "2" }
# 							.and {
# 								or! {
# 									tags *@tags
# 									tags nil
# 									and! {
# 										tags.not "3", "4"
# 									}
# 									and!.not {
# 										tags.start_with "5", "6"
# 										tags.not.start_with("7")
# 										tags.not.near("8", distance: 7)
# 										tags start_with("9"), near("10")
# 										tags term("11", boost: 2)
# 										tags.not phrase "12"
# 									}
# 									or!.not {
# 										price(25..100)
# 										price 100...200
# 										price gte(200).lt(300)
# 										price gte(300)
# 									}
# 									or! {
# 										created_at Date.today - 7
# 										created_at gte(Date.today)
# 										created_at gte(Date.today).lt(Date.today + 3)
# 									}
# 								}
# 							}

# 		q.compile

# 	end

# 	binding.pry


# end
