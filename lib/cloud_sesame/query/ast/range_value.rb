module CloudSesame
  module Query
    module AST
      class RangeValue < Abstract::Value

        def initialize(value = nil, type = nil)

          self.value = RangeValue.range?(value) ? range_handler(value) :
                       RangeValue.string_range?(value) ? string_handler(value) :
                       empty_value

          self.type = type if type
        end

        def type=(type)
          value_type_handler(type) if (@type = type)
          type
        end

        def gt(value)
          update_lower_value(value) if value
          return self
        end

        def gte(value)
          update_lower_value(value, '[') if value
          return self
        end

        def lt(value)
          update_uppoer_value(value) if value
          return self
        end

        def lte(value)
          update_uppoer_value(value, ']') if value
          return self
        end

        def to_s
          compile
        end

        def ==(object)
          value == RangeValue.new(object, Value).value
        end

        private

        def recompile(value)
          super "#{ value[0] }#{ value[1] },#{ value[2] }#{ value[3] }"
        end

        def update_lower_value(value, included = '{')
          self.value[0] = included
          self.value[1] = value
        end

        def update_uppoer_value(value, included = '}')
          self.value[2] = value
          self.value[3] = included
        end

        def range_handler(value)
          ['[', value.begin, value.end, value.exclude_end? ? '}' : ']']
        end

        def string_handler(value)
          RANGE_FORMAT.match(value.tr(' ', '')).captures
        end

        def value_type_handler(type)
          self.value[1, 2] = value[1, 2].map { |v| type.parse(v) unless v.is_a?(String) && v.empty? }
        end

        def empty_value
          ['{', nil, nil, '}']
        end

      end
    end
  end
end
