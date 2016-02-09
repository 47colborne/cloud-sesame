module CloudSesame
	module Query
		module AST
			class NumericValue < Value

				def compile
					data.to_s
				end

        def ==(value)
          value.to_f == data.to_f || value == compile
        end

			end
		end
	end
end
