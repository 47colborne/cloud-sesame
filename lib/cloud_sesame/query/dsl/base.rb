module CloudSesame
	module Query
		module DSL
			module Base

				private

				def dsl_scope
					self
				end

				def dsl_context
					dsl_scope.context
				end

				def dsl_return(node = nil)
					node || dsl_scope
				end

			end
		end
	end
end
