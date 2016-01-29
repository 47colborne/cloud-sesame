module CloudSesame
	module Query
		module DSL
			module FilterQueryMethods

				def included?(field, value = nil)
					!!(
						(field_options = _context[:fields][field.to_sym]) &&
						(applied = field_options[:applied]) &&
						(
							(!value && applied.values.any?) ||
							(
								value && (index = applied.keys.index(value)) &&
								(field_options[:applied].values[index] != false)
							)
						)
					)
				end

				def excluded?(field, value = nil)
					!!(
						(field_options = _context[:fields][field.to_sym]) &&
						(applied = field_options[:applied]) &&
						(
							(!value && !applied.values.all?) ||
							(
								value && (index = applied.keys.index(value)) &&
								field_options[:applied].values[index] == false
							)
						)
					)
				end

				def applied_filters
					applied = {}
					_context[:fields].each do |field, options|
						if options && options[:applied] &&
							!(values = options[:applied].select { |k, v| v }.keys).empty?
							applied[field] = values
						end
					end
					applied
				end

			end
		end
	end
end
