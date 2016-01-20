module CloudSesame
  module Query
    module AST
      class RangeValue < Value

        STRING_FORMAT = /\A(\[|{)(.*),(.*)(\}|\])\z/

        def initialize(value = nil)
          @data = if value.kind_of?(Range)
            ['[', Value.create(value.begin), Value.create(value.end), !value.exclude_end?]
          elsif value.is_a?(String) && (match = value.match STRING_FORMAT)
            @data = match.captures
          else
            ['{', nil, nil, '}']
          end
        end

        def compile
          "#{ lb }#{ data[1].to_s },#{ data[2].to_s }#{ ub }"
        end

        def gt(value = nil)
          data[0], data[1] = '{', Value.create(value) if value
          return self
        end

        def gte(value = nil)
          data[0], data[1] = '[', Value.create(value) if value
          return self
        end

        def lt(value = nil)
          data[2], data[3] = Value.create(value), '}' if value
          return self
        end

        def lte(value = nil)
          data[2], data[3] = Value.create(value), ']' if value
          return self
        end

        private

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
