module CloudSearch
	module Query
		module DSL
			module FilterQuery
				include Scope
				include And
				include Or
				include Literal

				# { fields: { tags: { excluded: [100] } } }
				def included?(field, value = nil)
					(field_options = method_scope.context[:fields][field]) && (
						(value && field_includes?(field_options, value)) ||
						(!value && field_included_is_not_empty?(field_options))
					)
				end

				def excluded?(field, value = nil)
					(field_options = method_scope.context[:fields][field]) && (
						(value && field_excludes?(field_options, value)) ||
						(!value && field_excluded_is_not_empty?(field_options))
					)
				end

				private

				def field_includes?(field_options, value)
					field_options[:included] && field_options[:included].include?(value)
				end

				def field_included_is_not_empty?(field_options)
					field_options[:included] && !field_options[:included].empty?
				end

				def field_excludes?(field_options, value)
					field_options[:excluded] && field_options[:excluded].include?(value)
				end

				def field_excluded_is_not_empty?(field_options)
					field_options[:excluded] && !field_options[:excluded].empty?
				end


			end
		end
	end
end
