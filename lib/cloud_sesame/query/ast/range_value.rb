module CloudSesame
  module Query
    module AST
      class RangeValue < Value

        def initialize(range = nil)
          @data = range && range.kind_of?(Range) ? [true, to_value(range.begin), to_value(range.end), !range.exclude_end?] : [false, nil, nil, false]
        end

        def compile
          "#{ lb }#{ data[1].to_s },#{ data[2].to_s }#{ ub }"
        end

        def gt(value = nil)
          data[0], data[1] = false, valufy(value) if value
          return self
        end

        def gte(value = nil)
          data[0], data[1] = true, valufy(value) if value
          return self
        end

        def lt(value = nil)
          data[2], data[3] = valufy(value), false if value
          return self
        end

        def lte(value = nil)
          data[2], data[3] = valufy(value), true if value
          return self
        end

        private

        def valufy(value)
          return value if value.kind_of? Value
          return DateValue.new(value) if value.kind_of?(Date) || value.kind_of?(Time)
          Value.new value
        end

        def lb
          data[1] && data[0] ? '[' : '{'
        end

        def ub
          data[2] && data[3] ? ']' : '}'
        end

      end
    end
  end
end
