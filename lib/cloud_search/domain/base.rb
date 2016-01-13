module CloudSearch
	module Domain
		class Base
			extend Forwardable

			attr_reader :searchable_class

			def_delegator :client, :config

			def_delegators 	:builder, :query, :terms,
																:page, :size,
																:sort, :and, :or,
																:included?, :excluded?

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

			def field(name, options = {})
				# define filter query fields
				context[:filter_query, true][:fields, true][name.to_sym] = {}

				# define query options fields
				define_query_options(name, options[:query]) if options[:query]

				# define facet options
				define_facet_options(name, options[:facet]) if options[:facet]
			end

			def define_query_options(name, query_options)
				context[:query_options, true][:fields, true][name.to_sym] = format_options(query_options)
			end

			def define_facet_options(name, facet_options)
				context[:facet, true][name.to_sym] = format_options(facet_options)
			end

			def scope(name, proc = nil, &block)
				block = proc unless block_given?
				context[:filter_query, true][:scopes, true][name.to_sym] = block
			end

			private

			def format_options(options)
				options.is_a?(Hash) ? options : {}
			end

		end
	end
end
