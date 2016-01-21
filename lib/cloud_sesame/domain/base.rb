module CloudSesame
	module Domain
		class Base
			extend Forwardable

			attr_accessor :definition
			attr_reader :searchable, :result

			def_delegator :client, :config

			def initialize(searchable)
				@searchable = searchable
			end

			def builder
				Query::Builder.new default_context, searchable
			end

			def client
				@client ||= Client.new
			end

			def default_context
				@default_context ||= Context.new
			end

			# DEFAULT CONTEXT METHODS
			# =========================================
			# sets default page size
			def default_size(value)
				default_context[:page]
				default_context[:page, {}][:size] = value
			end

			# sets field, and field options
			def field(name, options = {})
				field_name = (options[:as] || name)
				add_query field_name, options.delete(:query)
				add_facet field_name, options.delete(:facet)

				add_field_expression name.to_sym, options
			end

			def define_sloppiness(value)
				(default_context[:query] ||= {})[:sloppiness] = value.to_i
			end

			def define_fuzziness(proc = nil, &block)
				block = proc unless block_given?
				(default_context[:query] ||= {})[:fuzziness] = Query::Node::Fuzziness.new(&block)
			end

			def default_scope(proc, &block)
				scope :default, proc, &block
			end

			def scope(name, proc = nil, &block)
				block = proc unless block_given?
				((default_context[:filter_query] ||= {})[:scopes] ||= {})[name.to_sym] = block
			end

			private

			def ensure_hash(options)
				options.is_a?(Hash) ? options : {}
			end

			def add_query(name, options)
				((default_context[:query_options] ||= {})[:fields] ||= {})[name] = ensure_hash(options) if options
			end

			def add_facet(name, options)
				(default_context[:facet] ||= {})[name] = ensure_hash(options) if options
			end

			def add_field_expression(name, options)
				overriding_field_expression name, options
				create_default_field_expression name, options
				create_field_expression_writer name, options
			end

			def overriding_field_expression(name, options)
				fields = ((default_context[:filter_query] ||= {})[:fields] ||= {})
				if (as = options[:as]) && (existing = fields.delete(as))
					options.merge! existing
				end
			end

			def create_default_field_expression(name, options)
				if (block = options.delete(:default))
					(default_context[:filter_query][:default] ||= []) << block
				end
			end

			def create_field_expression_writer(name, options)
				Query::DSL::FieldMethods.send(:define_method, name) do |*values|
					literal name, *values
				end
			end

			def method_missing(name, *args, &block)
				b = builder
				b.send(name, *args, &block)
			rescue NoMethodError
				super
			end

		end
	end
end
