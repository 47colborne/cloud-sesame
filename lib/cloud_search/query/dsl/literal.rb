module CloudSearch
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

				def prefix(literals)
				  literals.each { |literal| literal.options[:prefix] = true }
				  method_return
				end

				private

				def fields
					method_context[:fields]
				end

				def method_missing(field, *values, &block)
				  if fields && (options = fields[field])
				    values.map { |value| literal(field, value, options) }
				  else
				    super
				  end
				end

			end
		end
	end
end
