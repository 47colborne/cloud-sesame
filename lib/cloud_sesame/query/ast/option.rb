module CloudSesame
	module Query
		module AST
			class Option
				SYMBOL = nil

				attr_accessor :value

				def initialize(value)
					@value = value
				end

				def compile
					" #{ SYMBOL }=#{ value }"
				end

			end
		end
	end
end
