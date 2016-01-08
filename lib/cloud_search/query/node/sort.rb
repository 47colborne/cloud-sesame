module CloudSearch
	module Query
		module Node
			class Sort < Abstract

				attr_reader :sorting_attributes

				def sorting_attributes
					@sorting_attributes ||= deserialize context[:sort]
				end

				def [](attribute)
					sorting_attributes[attribute.to_sym]
				end

				def []=(attribute, order = nil)
					sorting_attributes[attribute.to_sym] = order.to_sym if order
				end

				def compile
					(result = serialize(sorting_attributes)).empty? ? {} : { sort: result }
				end

				private

				def serialize(hash = {})
					hash.to_a.map { |i| i.join(' ') }.join(',')
				end

				def deserialize(string)
					Hash[*((string || "").split(',').map { |i| i.strip.split(' ').map(&:to_sym) }.flatten)]
				end

			end
		end
	end
end
