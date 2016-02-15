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
				(context[:page] ||= {})[:size] = value
			end

			def define_sloppiness(value)
				(context[:query] ||= {})[:sloppiness] = value.to_i
			end

			def define_fuzziness(&block)
				(context[:query] ||= {})[:fuzziness] = Query::Node::Fuzziness.new(&block)
			end

			def field(name, options = {})
				field_name = (options[:as] || name)
				add_query field_name, options.delete(:query)
				add_facet field_name, options.delete(:facet)
				add_field name.to_sym, options
			end

			def scope(name, proc = nil, &block)
				block = proc unless block_given?
				((context[:filter_query] ||= {})[:scopes] ||= {})[name.to_sym] = block
			end

			private

			def to_hash(options)
				options.is_a?(Hash) ? options : {}
			end

			def add_query(name, options)
				((context[:query_options] ||= {})[:fields] ||= {})[name] = to_hash(options) if options
			end

			def add_facet(name, options)
				(context[:facet] ||= {})[name] = to_hash(options) if options
			end

			def add_field(name, options)
				replace_existing_field options
				create_default_literal name, options
				create_field_accessor name
				(context[:filter_query][:fields] ||= {})[name] = options
			end

			def replace_existing_field(options)
				fields = ((context[:filter_query] ||= {})[:fields] ||= {})
				if (as = options[:as]) && (existing = fields.delete(as))
					options.merge! existing
				end
			end

			def create_default_literal(name, options)
				if (block = options.delete(:default))
					caller = block.binding.eval "self"
					node = Query::Domain::Literal.new(name, options, caller)._eval(&block)
					filter_query_defaults << node
				end
			end

			def filter_query_defaults
				context[:filter_query][:defaults] ||= []
			end

			def create_field_accessor(name)
				Query::DSL::FieldAccessors.send(:define_method, name) do |*values, &block|
					literal name, *values, &block
				end
			end

			def method_missing(name, *args, &block)
				builder.send(name, *args, &block)
			rescue NoMethodError
				_caller.send(name, *args, &block) if _caller
			rescue NoMethodError
				super
			end

		end
	end
end
