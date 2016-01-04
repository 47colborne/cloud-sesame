module CloudSearch
	module Domain
		class Base
			extend Forwardable
			include CloudSearch::Query::Methods

			def_delegator :client, :config

			def define_search(&block)
				instance_eval &block
			end

			def initialize(searchable_class)
				@searchable_class = searchable_class
			end

			def searchable_class
				@searchable_class
			end

			def client
				@client ||= Client.new
			end

		end
	end
end
