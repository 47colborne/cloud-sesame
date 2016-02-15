module CloudSesame
	module Query
		module DSL
			module ScopeAccessors

				def scopes(name = nil, *args)
					return _return if name.nil?

					defined_scopes = _scope.context[:scopes]
					if defined_scopes && (block = defined_scopes[name.to_sym])
						instance_exec(*args, &block)
						_return
					else
						raise Error::ScopeNotDefined
					end
				end

				private

				def method_missing(name, *args, &block)
					scopes name, *args
				rescue Error::ScopeNotDefined
					super
				end

			end
		end
	end
end
