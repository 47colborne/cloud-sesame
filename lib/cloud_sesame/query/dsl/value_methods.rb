module CloudSesame
	module Query
		module DSL
			module ValueMethods

				def to_value(value)
					return value if value.kind_of? Value
					return DateValue.new(value) if value.kind_of?(Date) || value.kind_of?(Time)
					return RangeValue.new(value) if value.kind_of?(Range) || (value.is_a?(String) &&RANGE_FORMAT =~ value)
					return NumericValue.new(value) if value.is_a?(Numeric) || (value.is_a?(String) && DIGIT_FORMAT =~ value)
					Value.new(value)
				end

			end
		end
	end
end
