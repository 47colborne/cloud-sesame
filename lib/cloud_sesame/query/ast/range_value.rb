module CloudSesame
  module Query
    module AST
      class RangeValue < Value

        STRING_FORMAT = /\A(\[|{)(.*),(.*)(\}|\])\z/

        def initialize(value = nil)
          @data = if value.kind_of?(Range)
            range_to_array(value)
          elsif value.is_a?(String) && (match = STRING_FORMAT.match value)
            @data = match.captures
          else
            default_range
          end
        end

        def compile
          "#{ lb }#{ l.to_s },#{ u.to_s }#{ ub }"
        end

        def gt(value = nil)
          data[0], data[1] = '{', Value.parse(value) if value
          return self
        end

        def gte(value = nil)
          data[0], data[1] = '[', Value.parse(value) if value
          return self
        end

        def lt(value = nil)
          data[2], data[3] = Value.parse(value), '}' if value
          return self
        end

        def lte(value = nil)
          data[2], data[3] = Value.parse(value), ']' if value
          return self
        end

        def l
          data[1]
        end

        def u
          data[2]
        end

        private

        def range_to_array(r)
          ['[', r.begin, r.end, end_symbol(r)]
        end

        def end_symbol(value)
          value.exclude_end? ? '}' : ']'
        end

        def default_range
          ['{', nil, nil, '}']
        end

        def lb
          data[1] ? data[0] : '{'
        end

        def ub
          data[2] ? data[3] : '}'
        end

      end
    end
  end
end
