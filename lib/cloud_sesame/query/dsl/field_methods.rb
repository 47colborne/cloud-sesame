module CloudSesame
	module Query
		module DSL
			module FieldMethods

				private

				def fields
					dsl_context[:fields]
				end

				def method_missing(field, *values, &block)
				  if fields && (options = fields[field])
				  	dsl_scope.children.field = field
				  	dsl_scope.children.dsl_return = dsl_return
				  	dsl_scope.children.insert_and_return_children values
				  else
				    super
				  end
				end

			end
		end
	end
end
