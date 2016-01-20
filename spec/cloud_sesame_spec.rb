require 'spec_helper'
require 'ruby-prof'
require 'benchmark'

describe CloudSesame do

	# AWS initializer
	# =======================================================
	require 'yaml'
	YAML.load_file('aws.yml').each do |key, value|
		ENV["AWS_#{ key }"] = value
	end

	# Domain Initializer /config/initializers/cloudsearch.rb
	# =======================================================
	require 'cloud_sesame'

	CloudSesame::Domain::Client.configure do |config|
		config.access_key = ENV['AWS_ACCESS_KEY_ID']
		config.secret_key = ENV['AWS_SECRET_ACCESS_KEY']
	end

	# Usage Example
	# =======================================================
	class Product
		include CloudSesame

		define_cloudsearch do
			# Product CloudSesame Config
			config.endpoint = ENV['AWS_ENDPOINT']
			config.region 	= ENV['AWS_REGION']

			default_size 100

			define_sloppiness 3

			define_fuzziness do
				max_fuzziness 3
				min_char_size 6
				fuzzy_percent 0.17
			end

			field :searchable_text, 		query: { weight: 2 }
			field :description, 				query: true
			field :tags

			field :affiliate_advertiser_ext_id, facet: { size: 50 }
			field :currency, 						facet: true
			field :discount_percentage, facet: { buckets: %w([10,100] [25,100] [50,100] [70,100]), method: 'interval' }
			field :manufacturer_name, 	facet: { size: 50 }
			field :price, 							facet: { buckets: %w([0,25] [25,50] [50,100] [100,200] [200,}), method: 'interval' }
			field :category_string, 		facet: { sort: 'bucket', size: 10_000 }
			field :created_at,					default: -> { gt Date.today }

			scope :shoes_by_brand, ->(brand = nil) { query("shoes").and { manufacturer_name brand }  if brand }
			scope :and_mens do
				and! { tags "men"}
			end

		end

	end

	def query

	end

	# profile the code
	n = 1000
	result = RubyProf.profile do
	# Benchmark.bm do |x|
		# x.report {
	  n.times do
				Product.cloudsearch.query("black   jacket").sort(price: :asc).page(1).size(1000).or {
			  				or! {
			  					tags("men", "women")
			  				}
			  				tags.not start_with("automotive"), "home"
			  				and! {
			  					price gt(100).lt(500)
				  				created_at gt(Date.today - 7)
				  				currency "CAD", "USD"
			  				}

							}.or {
								and! {
									tags "outdoor"
			  					price gt(200).lt(1000)
				  				created_at gt(Date.today - 7)
				  				currency "CAD", "USD"
			  				}
							}.compile

	  end
		# }
	end

	# print a graph profile to text
	# printer = RubyProf::GraphPrinter.new(result)
	printer = RubyProf::FlatPrinter.new(result)
	printer.print(STDOUT, {})

end
