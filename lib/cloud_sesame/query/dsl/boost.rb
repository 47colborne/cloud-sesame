# module CloudSesame
# 	module Query
# 		module DSL
# 			module Boost

# 				def compile_boost
# 					" boost=#{ @boost }" if @boost
# 				end

# 				def boost(value)
# 					@boost = value.to_i
# 					return self
# 				end

# 				alias_method :weight, :boost

# 			end
# 		end
# 	end
# end
