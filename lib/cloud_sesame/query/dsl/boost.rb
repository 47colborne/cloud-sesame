module CloudSesame
	module Query
		module DSL
			module Boost

				def boost(value)
					@boost = value.to_i
					return self
				end

				def compile_boost
					" boost=#{ @boost }" if @boost
				end

			end
		end
	end
end
