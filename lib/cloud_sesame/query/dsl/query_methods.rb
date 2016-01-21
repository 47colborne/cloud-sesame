module CloudSesame
	module Query
		module DSL
			module QueryMethods

				def query(input = false)
					if input || input.nil?
						request.query.query = input if input
						return self
					else
						request.query.query
					end
				end

			end
		end
	end
end
