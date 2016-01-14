module CloudSesame
  module Query
    module AST
      class RangeValue < Value

        attr_accessor :lower_bound_included,
                      :upper_bound_included

        def initialize
          @data = [nil, nil]
        end

        def compile
          strip "#{ lower_bound }#{ lower.compile if lower },#{ upper.compile if upper }#{ upper_bound }"
        end

        def to_s
          compile
        end

        def gt(value)
          self.lower = value
          self.lower_bound_included = false
          return self
        end

        def gte(value)
          self.lower = value
          self.lower_bound_included = true
          return self
        end

        def lt(value)
          self.upper = value
          self.upper_bound_included = false
          return self
        end

        def lte(value)
          self.upper = value
          self.upper_bound_included = true
          return self
        end

        def lower
          data[0]
        end

        def lower=(value)
          data[0] = to_value(value)
        end

        def upper
          data[1]
        end

        def upper=(value)
          data[1] = to_value(value)
        end

        def lower_bound
          lower && lower_bound_included ? '[' : '{'
        end

        def upper_bound
          upper && upper_bound_included ? ']' : '}'
        end

        private

        def to_value(value)
          value.kind_of?(Value) ? value : Value.new(value)
        end

      end
    end
  end
end
