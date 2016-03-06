module CloudSesame
  module Query
    module AST
      class DateValue < StringValue

        def self.parse(value)
          range?(value) || string_range?(value) ? RangeValue.parse(value, self) : new(value)
        end

        def to_s
          compile
        end

        private

        def recompile(value)
          super strip format value
        end

        def format(value)
          value.strftime '%FT%TZ'
        end

        def strip(value)
          value.tr(' ', '')
        end

      end
    end
  end
end
