module CloudSesame
	module Query
		module DSL
			module FieldMethods

				def literal(name, *values)
					name = name.to_sym
					if (fields = dsl_context[:fields]) && fields[name]
				  	dsl_scope.children.field = name
				  	dsl_scope.children.dsl_return = dsl_return
				  	dsl_scope.children.insert values
				  else
				  	false
				  end
				end

				private

				def method_missing(name, *values, &block)
				  (result = literal(name, *values)) ? result : super
				end

			end
		end
	end
end
