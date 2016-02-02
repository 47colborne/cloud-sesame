module CloudSesame
	module Query
		module DSL
			module RangeHelper

				def gt(input)
					AST::RangeValue.new.gt input
				end

				def gte(input)
					AST::RangeValue.new.gte input
				end

				def lt(input)
					AST::RangeValue.new.lt input
				end

				def lte(input)
					AST::RangeValue.new.lte input
				end

			end
		end
	end
end
