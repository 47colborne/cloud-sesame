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

        # if the value is already a range value object
        # set the type to Value and return the value
        # else determine the type of value and create it
        def self.parse(value)
          if value.kind_of?(RangeValue)
            value.type = self
            return value
          end

          (
            range_value?(value) ? RangeValue :
            numeric_value?(value) ? NumericValue :
            datetime?(value) ? DateValue : StringValue
          ).new(value, self)

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
