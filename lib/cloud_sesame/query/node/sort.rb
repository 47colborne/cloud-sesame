module CloudSesame
	module Query
		module Node
			class Sort < Abstract

				attr_writer :sorting_attributes

				def sorting_attributes
					@sorting_attributes ||= {}
				end

				def [](attribute)
					sorting_attributes[attribute.to_sym]
				end

				def []=(attribute, order = :desc)
					sorting_attributes[attribute.to_sym] = order.to_sym if order
				end

				def compile
					unless (compiled = serialize sorting_attributes).empty?
						compiled
					end
				end

				private

				def serialize(hash = {})
					hash.each_with_object("") do |(k, v), o|
						o << ',' unless o.empty?
						o << serialize_field(field_name(k), v)
					end
				end

				def serialize_field(name, value)
					"#{ name } #{ value }"
				end

				def field_name(key)
					context[:fields][key] && (name = context[:fields][key][:as]) ? name : key
				end

			end
		end
	end
end
