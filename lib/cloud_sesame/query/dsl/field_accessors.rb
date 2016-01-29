module CloudSesame
	module Query
		module DSL
			module FieldAccessors

				def literal(name, *values)
					name = name.to_sym
			  	_scope.children.field = name
			  	_scope.children._return = _return
			  	_scope.children.insert values
				end

			end
		end
	end
end
