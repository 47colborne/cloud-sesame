module CloudSesame
	module Query
		module DSL
			module ScopeAccessors

				def scopes(name = nil, *args)
					context_scopes = _scope.context[:scopes]
					if (name && context_scopes && (callback = context_scopes[name])) || name.nil?
						instance_exec(*args, &callback) if callback
						_return
					else
						raise NoMethodError, "scope[#{ name }] does not exist"
					end
				end

				private

				def method_missing(name, *args, &block)
					context_scopes = _scope.context[:scopes]
					if context_scopes && (callback = context_scopes[name])
						instance_exec *args, &callback
					  _return
					else
						super
					end
				end

			end
		end
	end
end
