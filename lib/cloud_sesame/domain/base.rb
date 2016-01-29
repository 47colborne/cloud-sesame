module CloudSesame
	module Domain
		class Base
			extend Forwardable

			def_delegator :client, :config

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
				@client ||= Client.new
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

			# TODO
			def default_scope(proc, &block)
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
				replace_existing_field name, options
				create_default_accessor name, options
				create_field_accessor name
				(context[:filter_query][:fields] ||= {})[name] = options
			end

			def replace_existing_field(name, options)
				fields = ((context[:filter_query] ||= {})[:fields] ||= {})
				if (as = options[:as]) && (existing = fields.delete(as))
					options.merge! existing
				end
			end

			def create_default_accessor(name, options)
				if (block = options.delete(:default))
					(context[:filter_query][:default] ||= []) << block
				end
			end

			def create_field_accessor(name)
				Query::DSL::FieldAccessors.send(:define_method, name) do |*values|
					literal name, *values
				end
			end

			def method_missing(name, *args, &block)
				builder.send(name, *args, &block)
			end

		end
	end
end
