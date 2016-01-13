module CloudSearch
	module Query
		module DSL
			module Base

				private

				def method_context
					method_scope.context
				end

				def method_return
					self
				end

				def method_scope
					self
				end

			end
		end
	end
end
