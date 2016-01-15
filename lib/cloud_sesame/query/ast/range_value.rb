module CloudSesame
  module Query
    module AST
      class RangeValue < Value

        def initialize(range = nil)
          if range
            @data = [true, to_value(range.begin), to_value(range.end), !range.exclude_end?]
          else
            @data = [false, nil, nil, false]
          end
        end

        def compile
          "#{ lbound }#{ data[1].to_s },#{ data[2].to_s }#{ ubound }"
        end

        def gt(value)
          data[0, 1] = false, value
          return self
        end

        def gte(value)
          data[0, 1] = true, value
          return self
        end

        def lt(value)
          data[2], data[3] = value, false
          return self
        end

        def lte(value)
          data[2], data[3] = value, true
          return self
        end

        def lbound
          data[1] && data[0] ? '[' : '{'
        end

        def ubound
          data[2] && data[3] ? ']' : '}'
        end

        private

        def to_value(value)
          value.kind_of?(Value) ? value : value.kind_of?(Date) || value.kind_of?(Time) ? DateValue.new(value) : Value.new(value)
        end

      end
    end
  end
end
