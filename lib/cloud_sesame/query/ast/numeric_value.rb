module CloudSesame
	module Query
		module AST
			class NumericValue < Abstract::Value

        def self.parse(value)
          range?(value) || string_range?(value) ? RangeValue.parse(value, self) : new(value)
        end

        def to_s
          compile
        end

        def ==(value)
          value == @value.to_f || value == @value || value == compile
        end

        private

        def recompile(value)
					super value.to_s
        end

			end
		end
	end
end
