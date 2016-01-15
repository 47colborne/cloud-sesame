module CloudSesame
	module Query
		module DSL
			module Page

				# CLAUSE: PAGE and SIZE
				# =========================================
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

				alias_method :limit,  :size

			end
		end
	end
end
