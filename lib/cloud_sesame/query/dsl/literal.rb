module CloudSesame
	module Query
		module DSL
			module Literal

				# NEAR: creates a single NEAR node
				# =======================================
				def near(value)
					create_literal_with_operator AST::Near, value
				end

				alias_method :n,			    :near
				alias_method :sloppy,     :near

				# PREFIX: creates a single PREFIX node
				# =======================================
				def prefix(value)
					create_literal_with_operator AST::Prefix, value
				end

				alias_method :p,					:prefix
				alias_method :start_with,	:prefix
				alias_method :begin_with, :prefix

				# PHRASE: creates a single PHRASE node
				# =======================================
				def phrase(value)
					create_literal_with_operator AST::Phrase, value
				end

				private

				def fields
					method_context[:fields]
				end

				def create_literal_with_operator(klass, value)
					if (field = method_scope.children.field) && fields[field]
						literal = AST::Literal.new field, value, fields[field]
						(node = klass.new method_context) << literal
						node
					end
				end

				def method_missing(field, *values, &block)
				  if fields && (options = fields[field])
				  	method_scope.children.field = field
				  	method_scope.children.insert_and_return_children values
				  else
				    super
				  end
				end

			end
		end
	end
end
