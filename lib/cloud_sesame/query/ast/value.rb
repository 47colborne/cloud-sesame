module CloudSesame
  module Query
    module AST
      class Value < Abstract::Value

        TYPES = {
          string: StringValue,
          numeric: NumericValue,
          datetime: DateValue
        }

        def self.map_type(symbol)
          (klass =TYPES[symbol]) ? klass : self
        end

        def self.parse(value)
          return value.parse self if value.kind_of?(RangeValue)
          (
            range_value?(value) ? RangeValue :
            numeric_value?(value) ? NumericValue :
            datetime_value?(value) ? DateValue : StringValue
          ).new(value, self)
        end

        def self.range_value?(value)
          range?(value) || string_range?(value)
        end

        def self.numeric_value?(value)
          numeric?(value) #|| string_numeric?(value)
        end

        def self.datetime_value?(value)
          datetime?(value) || string_datetime?(value) || string_time?(value)
        end

      end
    end
  end
end
