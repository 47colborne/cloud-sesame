module CloudSesame
	module Query
		module DSL
			module SortMethods

				def sort(input = false)
					if input.is_a?(Hash)
						request.sort.attributes = input
						return self
					elsif input
						request.sort[input] = nil
						return self
					elsif input.nil?
						return self
					else
						request.sort.attributes
					end
				end

			end
		end
	end
end
