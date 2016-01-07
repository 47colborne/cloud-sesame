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

		cloudsearch.define_search do

			# Product CloudSearch Config
			config.endpoint = ENV['AWS_ENDPOINT']
			config.region 	= ENV['AWS_REGION']

			default_size 20

			fields :currency, :price, :tags

		end

	end

	# result = Product.cloudsearch.text("shoes").page(3).size(100).sort(price: :asc)

	# a = Catalog::CloudSearchService.new()
	# Catalog::ProductSearchable.search_args(a.build_search_query)

	# # Examples

	# #name = val

	# Product.cloudsearch.where { name: val }

	# #name = val1 || val2

	# Product.cloudsearch.where {
	# 	or {
	# 		name val1, val2
	# 	}
	# }

	# #name = val1 && foo = bar
	# Product.cloudsearch.where {
	# 	and {
	# 		name val1
	# 		foo 'bar'
	# 	}
	# }

	# def context.>=(value)
	# 	"[#{value},}"
	# end
	# # price >= 10
	# Product.cloudsearch.where { price > 10 }

	# # (name = val & tag = a) or (tag in [a,b])

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


	result = Product.cloudsearch.where {
		and! {
			or! { currency 'USD', 'CAD' }
			or! { price "{10,100}"}
		}

	}
	binding.pry



end
