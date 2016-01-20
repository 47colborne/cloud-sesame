module CloudSesame
	module Query
		module DSL
			module ValueMethods

				RANGE_FORMAT = /\A[\[\{].*[\]\}]\z/
        DIGIT_FORMAT = /\A\d+(.\d+)?\z/
        SINGLE_QUATE = /\'/
        ESCAPE_QUATE = "\\'"

				def to_value(value)
					return value if value.kind_of? AST::Value
					return AST::DateValue.new(value) if value.kind_of?(Date) || value.kind_of?(Time)
					return AST::RangeValue.new(value) if value.kind_of?(Range) || (value.is_a?(String) &&RANGE_FORMAT =~ value)
					return AST::NumericValue.new(value) if value.is_a?(Numeric) || (value.is_a?(String) && DIGIT_FORMAT =~ value)
					AST::Value.new(value)
				end

        private

        def escape(data = "")
          "'#{ data.gsub(SINGLE_QUATE) { ESCAPE_QUATE } }'"
        end

        def strip(string)
          string.tr(" ", "")
        end

			end
		end
	end
end
