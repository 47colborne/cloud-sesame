module CloudSesame
	module Query
		module DSL
			module ScopeMethods

				def scopes
				  dsl_context[:scopes]
				end

				private

				def method_missing(name, *args, &block)
					if scopes && (callback = scopes[name])
						instance_exec *args, &callback
					  dsl_return
					else
						super
					end
				end

			end
		end
	end
end
