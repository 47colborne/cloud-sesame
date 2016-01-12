require 'spec_helper'
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
describe CloudSearch do

	# AWS initializer
	require 'yaml'
	YAML.load_file('aws.yml').each do |key, value|
		ENV["AWS_#{ key }"] = value
	end

	# Domain Initializer /config/initializers/cloudsearch.rb
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

			field :searchable_text, 		query: { weight: 2 }
			field :description, 				query: true
			field :tags

			field :affiliate_advertiser_ext_id, facet: { size: 50 }
			field :currency, 						facet: true
			field :discount_percentage, facet: { buckets: %w([10,100] [25,100] [50,100] [70,100]), method: 'interval' }
			field :manufacturer_name, 	facet: { size: 50 }
			field :price, 							facet: { buckets: %w([0,25] [25,50] [50,100] [100,200] [200,}), method: 'interval' }
			field :category_string, 		facet: { sort: 'bucket', size: 10_000 }

			# scope :newest -> { and! { tags "men" } }
			scope :test_scope, -> { binding.pry }

		end

	end

	result = Product.cloudsearch.query("shoes")
	.page(3)
	.or {
		test_scope
		not category_string 'men' #=> "category_string:'men' category_string:'women'"
		# prefix(category_string('men', 'women')) #=> "(prefix field=category_string 'men') (prefix field=category_string 'women')"
	}.and {
		and! { tags "flash_deal"; tags "sales" }
	}


	binding.pry


end
