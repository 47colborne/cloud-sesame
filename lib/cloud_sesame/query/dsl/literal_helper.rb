module CloudSesame
	module Query
		module DSL
			module LiteralHelper

				def d(date)
					AST::DateValue.new date
				end

				def r
					AST::RangeValue.new
				end

			end
		end
	end
end
