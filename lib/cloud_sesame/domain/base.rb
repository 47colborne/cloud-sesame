module CloudSesame
	module Domain
		class Base
			extend Forwardable

			def_delegators :client, :config, :caching_with

			attr_reader :searchable

			def self.definitions
				@definitions ||= {}
			end

			def initialize(searchable)
				@searchable = searchable
				@builder = Query::Builder.construct_class(searchable)
			end

			def builder
				@builder.new context, searchable
			end

			def client
				@client ||= Client.new searchable
			end

			def context
				@context ||= Context.new
			end

			# DEFAULT CONTEXT METHODS
			# =========================================

			def default_size(value)
				context_page[:size] = value.to_i
			end

			def define_sloppiness(value)
				context_query[:sloppiness] = Query::Node::Sloppiness.new(value)
			end

			def define_fuzziness(&block)
				context_query[:fuzziness] = Query::Node::Fuzziness.new(&block)
			end

			def field(name, options = {})
				field_name = (options[:as] || name).to_sym

				add_sort_alias(name, options) if options[:as]
				add_query_options(field_name, options) if options[:query]
				add_facet(field_name, options) if options[:facet]
				add_field(name, options)
			end

			def scope(name, proc = nil, &block)
				block = proc unless block_given?
				filter_query_scopes[name.to_sym] = block if block
			end

			private

			def add_sort_alias(name, options)
				context_sort_fields[name] = { as: options[:as] }
			end

			def add_query_options(name, options)
				context_query_options[name] = to_hash(options.delete(:query))
			end

			def add_facet(name, options)
				context_facet[name] = to_hash(options.delete(:facet))
			end

			def add_field(name, options)
				options = merge_with_as_field options if options[:as]
				options[:type] = set_type(options[:type])
				create_accessor name
				create_default_literal name, options
				filter_query_fields[name] = options
			end

			def set_type(type)
				Query::AST::Value.map_type(type)
			end

			def merge_with_as_field(options)
				(existing = filter_query_fields.delete(options[:as])) ? existing.merge(options) : options
			end

			def create_accessor(name)
				@builder.field_accessor.__define_accessor__(name)
			end

			def create_default_literal(name, options)
				if (block = options.delete(:default))
					caller = block.binding.eval "self"
					node = Query::Domain::Literal.new(name, options, caller)._eval(&block)
					filter_query_defaults << node if node
				end
			end

			def to_hash(options)
				options.is_a?(Hash) ? options : {}
			end

			def method_missing(name, *args, &block)
				builder.respond_to?(name) ? builder.send(name, *args, &block) :
				searchable.respond_to?(name) ? searchable.send(name, *args, &block) :
				super
			end

			# CONTEXT INITIALIZERS
			# =========================================

			def context_page
				context[:page] ||= {}
			end

			def context_query
				context[:query] ||= {}
			end

			def context_query_options
				(context[:query_options] ||= {})[:fields] ||= {}
			end

			def context_facet
				context[:facet] ||= {}
			end

			def context_sort_fields
				(context[:sort] ||= {})[:fields] ||= {}
			end

			def filter_query_fields
				(context[:filter_query] ||= {})[:fields] ||= {}
			end

			def filter_query_defaults
				(context[:filter_query] ||= {})[:defaults] ||= []
			end

			def filter_query_scopes
				(context[:filter_query] ||= {})[:scopes] ||= {}
			end

		end
	end
end
