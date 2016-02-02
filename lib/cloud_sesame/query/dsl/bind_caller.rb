module CloudSesame
	module Query
		module DSL
			module BindCaller

				private

				def _bind_caller_instance_variables
					_caller.instance_variables.each do |name|
						value = _caller.instance_variable_get name
						instance_variable_set name, value
					end
				end

				# ACCESS CALLER'S METHODS
				# =========================================
				def method_missing(name, *args, &block)
					_caller.send(name, *args, &block)
				rescue NoMethodError
					super
				end

			end
		end
	end
end
