module CloudSesame
	module Query
		module DSL
			module AppliedFilterQuery

				def included?(field, value = nil)
					applied?(field, value, true)
				end

				def excluded?(field, value = nil)
					applied?(field, value, false)
				end

				def applied?(field, value = nil, included = nil)
					field = field.to_sym
					applied = applied_filters(included)
					if value
						applied[field] && applied[field].include?(value)
					else
						applied[field] && !applied[field].empty?
					end
				end

				def applied_filters(included = nil)
					result = Hash.new { |hash, key| hash[key] = [] }

					(applied_fields = _scope.applied).flatten!
					applied_fields.compact!

					applied_fields.each do |field|
						if included.nil? || field[:included] == included
							result[field[:field]] << field[:value]
						end
					end

					result
				end

			end
		end
	end
end
