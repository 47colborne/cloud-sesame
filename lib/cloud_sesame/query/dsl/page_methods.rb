module CloudSesame
	module Query
		module DSL
			module PageMethods

				# CLAUSE: PAGE and SIZE
				# =========================================
				def page(input = false)
					if input || input.nil?
						request.page.start = nil
						request.page.page = (input || 1).to_i
						return self
					else
						request.page.page
					end
				end

				def start(input = false)
					if input || input.nil?
						request.page.page = nil
						request.page.start = input.to_i
						return self
					else
						request.page.start
					end
				end

				alias_method :offset,  :start

				def size(input = false)
					if input
						request.page.size = input.to_i
						return self
					elsif input.nil?
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
