module CloudSesame
	module Query
		module DSL
			module Value

				def d(date)
					AST::DateValue.new date
				end

				def r(range = nil)
					AST::RangeValue.new range
				end

			end
		end
	end
end
