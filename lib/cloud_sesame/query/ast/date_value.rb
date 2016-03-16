module CloudSesame
  module Query
    module AST
      class DateValue < StringValue

        COMPILE_FORMAT = '%FT%TZ'.freeze
        DATETIME_FORMAT = '%FT%T'.freeze
        DATE_FORMAT = '%F'.freeze

        def self.parse(value)
          if value.kind_of?(RangeValue)
            value.type = self
            return value
          end

          range?(value) || string_range?(value) ? RangeValue.new(value, self) :
          string_datetime?(value) ? new(parse_datetime(value)) :
          string_date?(value) ? new(parse_date(value)) :
          new(value)
        end

        def to_s
          compile
        end

        private

        def self.parse_datetime(string)
          DateTime.strptime(string, DATETIME_FORMAT)
        end

        def self.parse_date(string)
          Date.strptime(string, DATE_FORMAT)
        end

        def recompile(value)
          super strip format value
        end

        def format(value)
          value.strftime COMPILE_FORMAT
        end

      end
    end
  end
end
