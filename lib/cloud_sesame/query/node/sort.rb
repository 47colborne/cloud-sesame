module CloudSesame
	module Query
		module Node
			class Sort < Abstract

				attr_writer :sorting_attributes

				def sorting_attributes
					@sorting_attributes ||= deserialize context[:sort]
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
					hash.each.reduce("") do |result, (key, value)|
						result << ',' unless result.empty?
						result << "#{ key } #{ value }"
						result
					end
				end

				def deserialize(string)
					Hash[*((string || "").split(',').map { |i| i.strip.split(' ').map(&:to_sym) }.flatten)]
				end

			end
		end
	end
end
