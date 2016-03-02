module CloudSesame
	module Query
		module DSL
			module AppliedFilterQuery

				def included?(field, value = nil)
					field = field.to_sym
					applied = applied_filters(true)
					if value
						 applied[field] && applied[field].include?(value)
					else
						applied[field] && !applied[field].empty?
					end
				end

				def excluded?(field, value = nil)
					field = field.to_sym
					applied = applied_filters(false)
					if value
						applied[field] && applied[field].include?(value)
					else
						applied[field] && !applied[field].empty?
					end
				end

				def applied_filters(included = nil)
					applied = Hash.new { |hash, key| hash[key] = [] }
					_scope.applied.flatten.compact.each do |result|
						if included.nil? || result[:included] == included
							applied[result[:field]] << result[:value]
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
