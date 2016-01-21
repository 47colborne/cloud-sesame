module CloudSesame
	module Query
		module DSL
			module FilterQueryMethods

				def included?(field, value = nil)
					!!(
						(field_options = dsl_context[:fields][field]) &&
						(active_values = field_options[:active_values]) &&
						(
							(!value && active_values.values.any?) ||
							(
								value && (index = active_values.keys.index(value)) &&
								(field_options[:active_values].values[index] != false)
							)
						)
					)
				end

				def excluded?(field, value = nil)
					!!(
						(field_options = dsl_context[:fields][field]) &&
						(active_values = field_options[:active_values]) &&
						(
							(!value && !active_values.values.all?) ||
							(
								value && (index = active_values.keys.index(value)) &&
								field_options[:active_values].values[index] == false
							)
						)
					)
				end

			end
		end
	end
end
