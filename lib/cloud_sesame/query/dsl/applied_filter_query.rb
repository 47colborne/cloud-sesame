module CloudSesame
	module Query
		module DSL
			module AppliedFilterQuery

				def included?(field, value = nil)
					return false unless (options = field_options_for(field)) && (applied = options[:applied])
					if value
						(index = applied.keys.index(value)) &&
						(applied.values[index] != false)
					else
						applied.values.any?
					end
				end

				def excluded?(field, value = nil)
					return false unless (options = field_options_for(field)) && (applied = options[:applied])
					if value
						(index = applied.keys.index(value)) &&
						(applied.values[index] == false)
					else
						!applied.values.all?
					end
				end

				def applied_filters
					applied = {}
					_context[:fields].each do |field, options|
						if options && options[:applied] &&
							!(values = options[:applied].select { |_, v| v }.keys).empty?
							applied[field] = values
						end
					end
					applied
				end

				private

				def field_options_for(field)
					_context[:fields][field.to_sym]
				end

			end
		end
	end
end
