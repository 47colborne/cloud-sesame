module CloudSesame
	module Query
		module DSL
			module FieldMethods

				private

				def method_missing(field, *values, &block)
				  if (fields = dsl_context[:fields]) && fields[field]
				  	dsl_scope.children.field = field
				  	dsl_scope.children.dsl_return = dsl_return
				  	dsl_scope.children.insert values
				  else
				    super
				  end
				end

			end
		end
	end
end
