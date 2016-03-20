module CloudSesame
  module Query
    module AST
      class RangeValue < Abstract::Value

        def initialize(value = nil, type = nil)
          self.value =  RangeValue.range?(value) ? build_from_range(value) :
                        RangeValue.string_range?(value) ? build_from_string(value) :
                        initialize_value
          self.parse type
        end

        def parse(type)
          if type && type.respond_to?(:parse)
            @changed = true
            value[1] = type.parse(self.begin) unless self.begin.to_s.empty?
            value[2] = type.parse(self.end) unless self.end.to_s.empty?
          end
          return self
        end

        def begin
          value[1]
        end

        def end
          value[2]
        end

        def lower_bound
          value[0]
        end

        def upper_bound
          value[3]
        end

        def gt(value)
          set_begin(value) if value
          return self
        end

        def gte(value)
          set_begin(value, '[') if value
          return self
        end

        def lt(value)
          set_end(value) if value
          return self
        end

        def lte(value)
          set_end(value, ']') if value
          return self
        end

        def to_s
          compile
        end

        def ==(object)
          value == (object.is_a?(RangeValue) ? object : RangeValue.new(object, Value)).value
        end

        private

        def recompile(value)
          super "#{ value[0] }#{ value[1] },#{ value[2] }#{ value[3] }"
        end

        def set_begin(value, included = '{')
          @changed = true
          self.value[0, 2] = [included, value]
        end

        def set_end(value, included = '}')
          @changed = true
          self.value[2, 2] = [value, included]
        end

        def build_from_range(range)
          initialize_value('[', range.begin, range.end, range.exclude_end? ? '}' : ']')
        end

        def build_from_string(string)
          initialize_value(*RANGE_FORMAT.match(strip(string)).captures)
        end

        def initialize_value(lb = '[', bv = nil, ev = nil, up = ']')
          [lb, bv, ev, up]
        end

      end
    end
  end
end
