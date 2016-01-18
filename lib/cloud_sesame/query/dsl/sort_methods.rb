module CloudSesame
	module Query
		module DSL
			module SortMethods

				def sort(input = nil)
					if input.is_a? Hash
						input.each { |key, value| request.sort[key] = value }
						return self
					elsif input
						request.sort[input]
					else
						request.sort.sorting_attributes
					end
				end

			end
		end
	end
end
