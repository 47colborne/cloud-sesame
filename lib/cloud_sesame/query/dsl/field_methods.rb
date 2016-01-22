module CloudSesame
	module Query
		module DSL
			module FieldMethods

				def literal(name, *values)
					name = name.to_sym
			  	dsl_scope.children.field = name
			  	dsl_scope.children.dsl_return = dsl_return
			  	dsl_scope.children.insert values
				end

			end
		end
	end
end
