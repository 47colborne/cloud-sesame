module CloudSesame
	module Query
		module DSL
			module ScopeMethods

				def scopes(name = nil, *args)
					if (name && context_scopes && (callback = context_scopes[name])) || name.nil?
						instance_exec(*args, &callback) if callback
						dsl_return
					else
						raise NoMethodError, "scope[#{ name }] does not exist"
					end
				end

				private

				def context_scopes
					dsl_context[:scopes]
				end

				def method_missing(name, *args, &block)
					if context_scopes && (callback = context_scopes[name])
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
