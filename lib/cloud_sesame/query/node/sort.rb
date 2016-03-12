module CloudSesame
	module Query
		module Node
			class Sort < Abstract

				attr_writer :attributes

				def attributes
					@attributes ||= {}
				end

				def [](attribute)
					attributes[attribute.to_sym]
				end

				def []=(attribute, order)
					attributes[attribute.to_sym] = order
				end

				def compile
					unless (compiled = serialize attributes).empty?
						compiled
					end
				end

				private

				def serialize(hash)
					hash.each_with_object("") do |(k, v), o|
						o << (o.empty? ? '' : ',') << serialize_field(k, v)
					end
				end

				def serialize_field(name, value)
					"#{ field_name(name) } #{ value }"
				end

				def field_name(key)
					(name = alias_field(key)) ? name : key
				end

				def alias_field(key)
					context[:fields] &&
					context[:fields][key] &&
					context[:fields][key][:as]
				end

			end
		end
	end
end
