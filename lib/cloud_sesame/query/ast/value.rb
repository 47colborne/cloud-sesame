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
          if value.kind_of?(RangeValue)
            value.type = self
            value
          elsif range?(value) || string_range?(value)
            RangeValue.new(value, self)
          elsif numeric?(value) || string_numeric?(value)
            NumericValue.new(value)
          elsif datetime?(value)
            DateValue.new(value)
          else
            StringValue.new(value)
          end
        end

      end
    end
  end
end
