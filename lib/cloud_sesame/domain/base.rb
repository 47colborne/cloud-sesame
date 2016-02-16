module CloudSesame
	module Domain
		class Base
			extend Forwardable

			def_delegators :client, :config, :caching_with

			attr_accessor :_caller
			attr_reader :searchable

			def self.definitions
				@definitions ||= {}
			end

			def initialize(searchable)
				@searchable = searchable
			end

			def builder
				Query::Builder.new context, searchable
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
				page[:size] = value.to_i
			end

			def define_sloppiness(value)
				query[:sloppiness] = Query::Node::Sloppiness.new(value)
			end

			def define_fuzziness(&block)
				query[:fuzziness] = Query::Node::Fuzziness.new(&block)
			end

			def field(name, options = {})
				field_name = (options[:as] || name)
				add_query(field_name, options.delete(:query)) if options[:query]
				add_facet(field_name, options.delete(:facet)) if options[:facet]
				add_field(name.to_sym, options)
			end

			def scope(name, proc = nil, &block)
				block = proc unless block_given?
				filter_query_scopes[name.to_sym] = block if block
			end

			private

			def to_hash(options)
				options.is_a?(Hash) ? options : {}
			end

			def add_query(name, options)
				((context[:query_options] ||= {})[:fields] ||= {})[name] = to_hash(options)
			end

			def add_facet(name, options)
				(context[:facet] ||= {})[name] = to_hash(options)
			end

			def add_field(name, options)
				options = merge_with_as_field options if options[:as]
				create_default_literal name, options
				create_field_accessor name
				filter_query_fields[name] = options
			end

			def merge_with_as_field(options)
				(existing = filter_query_fields.delete(options[:as])) ? existing.merge(options) : options
			end

			def create_default_literal(name, options)
				if (block = options.delete(:default))
					caller = block.binding.eval "self"
					domain = Query::Domain::Literal.new(name, options, caller)
					node = domain._eval(&block)
					filter_query_defaults << node if node
				end
			end

			def create_field_accessor(name)
				Query::DSL::FieldAccessors.__define_accessor__(name)
			end

			def method_missing(name, *args, &block)
				if builder.respond_to?(name)
					builder.send(name, *args, &block)
				elsif searchable.respond_to?(name)
					searchable.send(name, *args, &block)
				else
					super
				end
			end

			# CONTEXT ACCESSORS
			# =========================================

			def page
				context[:page] ||= {}
			end

			def query
				context[:query] ||= {}
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
