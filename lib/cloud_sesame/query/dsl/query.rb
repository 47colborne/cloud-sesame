module CloudSesame
	module Query
		module DSL
			module Query

				def query(input = nil)
					if input
						request.query.query = input
						return self
					else
						request.query.query
					end
				end

			end
		end
	end
end
