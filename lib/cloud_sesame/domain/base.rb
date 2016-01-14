module CloudSesame
	module Domain
		class Base
			extend Forwardable
			include Query::DSL::Scope

			attr_accessor :definition
			attr_reader :searchable

			def_delegator :client, :config

			def_delegators 	:builder, :query, :page, :size, :sort,
																:and, :or, :included?, :excluded?,
																:method_context, :method_return, :method_scope

			def initialize(searchable)
				@searchable = searchable
			end

			def client
				@client ||= Client.new
			end

			def builder
				@builder ||= CloudSesame::Query::Builder.new context, searchable
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
				field_name = options[:as] || name
				define_query_options(field_name, options.delete(:query)) if options[:query]
				define_facet_options(field_name, options.delete(:facet)) if options[:facet]
				define_filter_query_field(name, options)
			end

			def default_scope(proc, &block)
				scope :default, proc, &block
			end

			def scope(name, proc = nil, &block)
				block = proc unless block_given?
				context[:filter_query, true][:scopes, true][name.to_sym] = block
			end

			private

			def format_options(options)
				options.is_a?(Hash) ? options : {}
			end

			def define_filter_query_field(name, options)
				if (as = options[:as]) && (existing_options = context[:filter_query, true][:fields, true].delete(as))
					options.merge!(existing_options)
				end
				context[:filter_query, true][:fields, true][name.to_sym] = options
			end

			def define_query_options(name, options)
				context[:query_options, true][:fields, true][name.to_sym] = format_options(options)
			end

			def define_facet_options(name, options)
				context[:facet, true][name.to_sym] = format_options(options)
			end

		end
	end
end
