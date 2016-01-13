module CloudSearch
	module Query
		module DSL
			module Or

				# CLAUSE: OR
				# =========================================
				def or(&block)
				  method_scope.children << AST::Or.new(method_context, &block)
				  method_return
				end

				alias_method :any, :or
				alias_method :or!, :or

			end
		end
	end
end
