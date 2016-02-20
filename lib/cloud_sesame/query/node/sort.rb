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
					compiled unless (compiled = serialize sorting_attributes).empty?
				end

				private

				def serialize(hash = {})
					hash.to_a.map { |i| i.join(' ') }.join(',')
				end

				def deserialize(serialized_attributes)
					if string
						string.split(',').map do ||
							i.strip.split(' ')
						end
						[*]
					Hash[*((string || "").split(',').map { |i| i.strip.split(' ').map(&:to_sym) }.flatten)]
				end

			end
		end
	end
end
