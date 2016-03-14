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

				def applied?(field, value, included = nil)
					field = field.to_sym
					applied = applied_filters(included)
					if value
						applied[field] && applied[field].include?(value)
					else
						applied[field] && !applied[field].empty?
					end
				end

				def applied_filters(included = nil)
					applied = Hash.new { |hash, key| hash[key] = [] }
					_scope.applied.flatten!.compact!.each do |result|
						if included.nil? || result[:included] == included
							applied[result[:field]] << result[:value]
						end
					end
					applied
				end

			end
		end
	end
end
