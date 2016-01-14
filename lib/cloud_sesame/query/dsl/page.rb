module CloudSesame
	module Query
		module DSL
			module Page

				def page(input = nil)
					if input
						request.page.page = input.to_i
						return self
					else
						request.page.page
					end
				end

				def size(input)
					if input
						request.page.size = input.to_i
						return self
					else
						request.page.size
					end
				end

			end
		end
	end
end
