module CloudSesame
	module Query
		module DSL
			module And

				# CLAUSE: AND
				# =========================================
				def and(&block)
				  method_scope.children << AST::And.new(method_context, &block)
				  method_return
				end

				alias_method :all,  :and
				alias_method :and!, :and

			end
		end
	end
end
