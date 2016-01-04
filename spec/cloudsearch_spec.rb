require 'spec_helper'

describe CloudSearch do

	require 'yaml'

	YAML.load_file('aws.yml').each do |key, value|
		ENV["AWS_#{ key }"] = value
	end

	CloudSearch::Domain::Client.configure do |config|
		config.access_key = ENV['AWS_ACCESS_KEY_ID']
		config.secret_key = ENV['AWS_SECRET_ACCESS_KEY']
	end

	class Product
		include CloudSearch

		cloudsearch.define_search do

			# Product CloudSearch Config
			config.endpoint = ENV['AWS_ENDPOINT']
			config.region 	= ENV['AWS_REGION']

			query.default_size = 10

		end

	end

	result = Product.cloudsearch.text("shoes")
	# 								.where("price = {:min, :max}", min: 10, max: 100)
	# 								.where("price = {10, 100}")
	# 								.where(price: "{10, 100}")
	# 								.where("price > 10")

	binding.pry

end
