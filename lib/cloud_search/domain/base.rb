module CloudSearch
	module Domain
		class Base
			extend Forwardable

			attr_reader :searchable_class

			def_delegator :client, :config

			def_delegators 	:builder, :query, :terms,
																:page, :size,
																:sort, :and, :or

			def initialize(searchable_class)
				@searchable_class = searchable_class
			end

			def client
				@client ||= Client.new
			end

			def builder
				@builder ||= CloudSearch::Query::Builder.new context, searchable_class
			end

			# DEFAULT CONTEXT METHODS
			# =========================================

			def context
				@context ||= Context.new
			end

			def default_size(value)
				context[:page, true][:size] = value
			end

			def fields(*names)
				options = names[-1].is_a?(Hash) ? names.pop : {}
				names.each { |name| field name, options }
			end

			def field(name, options = {})
				context[:filter_query, true][:fields, true][name.to_sym] = options
			end

		end
	end
end
