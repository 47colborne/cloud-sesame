require 'spec_helper'

describe CloudSesame, focus: true do

	# # AWS initializer
	# require 'yaml'
	# YAML.load_file('aws.yml').each do |key, value|
	# 	ENV["AWS_#{ key }"] = value
	# end

	# # Domain Initializer /config/initializers/cloudsearch.rb
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

	# 		scope :men_tag, -> { tags "men" }
	# 		scope :and_mens, -> { and! { tags "men"} }

	# 	end

	# end

	# result = Product.cloudsearch.query("shoes")
	# .page(3)
	# .or {
	# 	price 100
	# 	tags.not.start_with 'home', 'outdoor'
	# }

	# # result.included?(price: 100)
	# binding.pry

end