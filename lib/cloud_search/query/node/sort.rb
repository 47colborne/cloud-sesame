module CloudSearch
	module Query
		module Node
			class Sort

				def add(attribute, order = :asc)
					attributes[attribute.to_sym] = order
				end

				def run
					{ sort: serialized_attributes }
				end

				private

				def serialized_attributes
					attributes.to_a.map { |array| array.join(' ') }.join(',')
				end

				def attributes
					@attributes ||= {}
				end

			end
		end
	end
end
