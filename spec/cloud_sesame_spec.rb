require 'spec_helper'

describe CloudSesame do

	# # AWS initializer
	# require 'yaml'
	# YAML.load_file('aws.yml').each do |key, value|
	# 	ENV["AWS_#{ key }"] = value
	# end

	# # Domain Initializer /config/initializers/cloudsearch.rb
	# require 'cloud_sesame'

	# CloudSesame::Domain::Client.configure do |config|
	# 	config.access_key = ENV['AWS_ACCESS_KEY_ID']
	# 	config.secret_key = ENV['AWS_SECRET_ACCESS_KEY']
	# end

	# # Usage Example
	# class Product
	# 	include CloudSesame

	# 	define_cloudsearch do
	# 		# Product CloudSesame Config
	# 		config.endpoint = ENV['AWS_ENDPOINT']
	# 		config.region 	= ENV['AWS_REGION']

	# 		default_size 100

	# 		define_sloppiness 3

	# 		define_fuzziness do
	# 			max_fuzziness 3
	# 			min_char_size 6
	# 			fuzzy_percent 0.17
	# 		end

	# 		field :searchable_text, 		query: { weight: 2 }
	# 		field :description, 				query: true
	# 		field :tags

	# 		field :affiliate_advertiser_ext_id, facet: { size: 50 }
	# 		field :currency, 						facet: true
	# 		field :discount_percentage, facet: { buckets: %w([10,100] [25,100] [50,100] [70,100]), method: 'interval' }
	# 		field :manufacturer_name, 	facet: { size: 50 }
	# 		field :price, 							facet: { buckets: %w([0,25] [25,50] [50,100] [100,200] [200,}), method: 'interval' }
	# 		field :category_string, 		facet: { sort: 'bucket', size: 10_000 }
	# 		field :created_at

	# 		scope :shoes_by_brand, ->(brand = nil) { query("shoes").and { manufacturer_name brand }  if brand }
	# 		scope :and_mens do
	# 			and! { tags "men"}
	# 		end

	# 	end

	# end

	# class NewProduct < Product
	# 	load_definition_from Product

	# 	define_cloudsearch do
	# 		field :searchable_text, 		query: { weight: 4 }
	# 		field :name, as: :text1
	# 	end
	# end

	# # Example Query
	# query = Product.cloudsearch.shoes_by_brand("puma").and_mens

	# # .and {
	# # 	or!(boost: 2) {
	# # 		# tags.not start_with "flash_deal"
	# # 		tags.not.start_with "flash_deal"
	# # 		# tags.near"sales"
	# # 		# tags start_with("flash_deal"), near("sales")
	# # 	}
	# # 	or!.not {
	# # 		currency "CAD", "EUR"
	# # 	}
	# # 	and! {
	# # 		price r.gte(100).lt(200)
	# # 	}


	# binding.pry

end
