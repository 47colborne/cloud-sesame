module CloudSesame
	module Query
		module DSL
			module Literal

				# CLAUSE: LITERAL
				# =========================================
				def literal(field, value, options = {})
				  node = AST::Literal.new(field, value, options)
				  method_scope.children << node
				  node
				end

				private

				def fields
					method_context[:fields]
				end

				def method_missing(field, *values, &block)
				  if fields && (options = fields[field])
				  	method_scope.children.field = field
				  	method_scope.children.insert_and_return_children(values)
				  else
				    super
				  end
				end

			end
		end
	end
end
