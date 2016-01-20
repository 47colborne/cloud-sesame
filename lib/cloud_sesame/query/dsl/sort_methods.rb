module CloudSesame
	module Query
		module DSL
			module SortMethods

				def sort(input = false)
					if input.is_a? Hash
						request.sort = input
						return self
					elsif input
						request.sort[input]
					elsif input.nil?
						return self
					else
						request.sort.sorting_attributes
					end
				end

			end
		end
	end
end
