module CloudSesame
	module Query
		module DSL
			module Base

				private

				def scope
					self
				end

				def scope_context
					scope.context
				end

				def scope_return(node = nil)
					node || self
				end

			end
		end
	end
end
