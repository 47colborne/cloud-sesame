require 'spec_helper'

describe CloudSearch do

	# AWS initializer
	require 'yaml'
	YAML.load_file('aws.yml').each do |key, value|
		ENV["AWS_#{ key }"] = value
	end

	# Domain Initializer
	CloudSearch::Domain::Client.configure do |config|
		config.access_key = ENV['AWS_ACCESS_KEY_ID']
		config.secret_key = ENV['AWS_SECRET_ACCESS_KEY']
	end

	# Usage Example
	class Product
		include CloudSearch

		define_cloudsearch do

			# Product CloudSearch Config
			config.endpoint = ENV['AWS_ENDPOINT']
			config.region 	= ENV['AWS_REGION']

			default_size 20

			fields :currency, :price, :tags

		end

	end

	# Product.cloudsearch.where {
	# 	or(tag: ['a', 'b'],
	# 		and(name: 'val', tag: 'a'))

	# 	or {
	# 		tag = 'a' => object = value
	# 		tag 'a'		=> object(value)
	# 		tag = 'b'
	# 		and {
	# 			name = 'val'
	# 			tag = 'a'
	# 		}
	# 	}
	# }

	# date(between(a, b))
	# date greater_than a, :inclusive

	result = Product.cloudsearch.query("shoes")
	.page(3)
	.size(100)
	.and {
		or! {
			tags "flash_deal"
			tags "sales"
		}
		or! {
			currency "USD"
			currency "CAD"
		}
	}.or {
		price "scott"
		price "alice"
	}

	binding.pry



end
