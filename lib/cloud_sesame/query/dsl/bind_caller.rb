module CloudSesame
	module Query
		module DSL
			module BindCaller

				def _caller=(caller)
					__bind_caller_instance_variables__(caller) if caller
					@_caller = caller
				end

				private

				def __bind_caller_instance_variables__(caller)
					caller.instance_variables.each do |name|
						value = caller.instance_variable_get name
						instance_variable_set name, value
					end
				end

				# ACCESS CALLER'S METHODS
				# =========================================
				def method_missing(name, *args, &block)
					if _caller && _caller.respond_to?(name, *args, &block)
						_caller.send(name, *args, &block)
					else
						super
					end
				end

			end
		end
	end
end
