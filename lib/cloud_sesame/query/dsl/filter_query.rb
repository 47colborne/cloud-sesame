module CloudSesame
	module Query
		module DSL
			module FilterQuery

				# FilterQuery DSL
				include Scope
				include And
				include Or
				include Literal
				include Value

				def included?(field, value = nil)
					(field_options = method_scope.context[:fields][field]) && (
						(value && field_options_is(:included, field_options, value)) ||
						(!value && field_options_not_empty_in(:included, field_options))
					)
				end

				def excluded?(field, value = nil)
					(field_options = method_scope.context[:fields][field]) && (
						(value && field_options_is(:excluded, field_options, value)) ||
						(!value && field_options_not_empty_in(:excluded, field_options))
					)
				end

				private

				def field_options_is(type, field_options, value)
					(values = field_options[type]) && values.include?(value)
				end

				def field_options_not_empty_in(type, field_options)
					field_options[type] && !field_options[type].empty?
				end


			end
		end
	end
end
