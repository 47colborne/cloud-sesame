module CloudSesame
  module Query
    module AST
      class RangeValue < Value

        def initialize(range = nil)
          @data = range ? [true, to_value(range.begin), to_value(range.end), !range.exclude_end?] : [false, nil, nil, false]
        end

        def compile
          "#{ lb }#{ data[1].to_s },#{ data[2].to_s }#{ ub }"
        end

        def gt(value)
          data[0], data[1] = false, to_value(value)
          return self
        end

        def gte(value)
          data[0], data[1] = true, to_value(value)
          return self
        end

        def lt(value)
          data[2], data[3] = to_value(value), false
          return self
        end

        def lte(value)
          data[2], data[3] = to_value(value), true
          return self
        end

        private

        def to_value(value)
          value.kind_of?(Value) ? value : value.kind_of?(Date) || value.kind_of?(Time) ? DateValue.new(value) : Value.new(value)
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
