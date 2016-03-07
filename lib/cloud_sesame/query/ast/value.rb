module CloudSesame
  module Query
    module AST
      class Value < Abstract::Value

        TYPES = {
          string: StringValue,
          numeric: NumericValue,
          date: DateValue
        }

        def self.map_type(symbol)
          (klass =TYPES[symbol]) ? klass : self
        end

        def self.parse(value)
          value.type = self and return value if value.kind_of?(RangeValue)
          (
            range_value?(value) ? RangeValue :
            numeric_value? ? NumericValue :
            datetime?(value) ? DateValue : StringValue
          ).new(value, type)

        end

        def self.range_value?(value)
          range?(value) || string_range?(value)
        end

        def self.numeric_value?(value)
          numeric?(value) || string_numeric?(value)
        end

      end
    end
  end
end
