module CloudSesame
	module Query
		module DSL
			module Scope

				def scopes
				  method_context[:scopes]
				end

				private

				def method_missing(name, *args, &block)
					if scopes && (callback = scopes[name])
						self.instance_exec *args, &callback
					  method_return
					else
						super
					end
				end

			end
		end
	end
end
