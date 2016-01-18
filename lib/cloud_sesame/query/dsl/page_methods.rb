module CloudSesame
	module Query
		module DSL
			module PageMethods

				# CLAUSE: PAGE and SIZE
				# =========================================
				def page(input = nil)
					if input
						request.page.start = nil
						request.page.page = input.to_i
						return self
					else
						request.page.page
					end
				end

				def start(input = nil)
					if input
						request.page.page = nil
						request.page.start = input.to_i
						return self
					else
						request.page.start
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
