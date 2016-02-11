module CloudSesame
	module Query
		module AST
			class NumericValue < Value

				def compile
					data.to_s
				end

        def ==(value)
          value == data.to_f ||
          value == data ||
          value == compile
        end

			end
		end
	end
end
