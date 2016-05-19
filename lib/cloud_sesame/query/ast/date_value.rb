module CloudSesame
  module Query
    module AST
      class DateValue < StringValue

        COMPILE_FORMAT = '%FT%TZ'.freeze
        DATETIME_FORMAT = '%FT%T'.freeze
        TIME_FORMAT = '%F %T %z'.freeze
        DATE_FORMAT = '%F'.freeze

        def self.parse(value)
          return value.parse self if value.kind_of?(RangeValue)
          range?(value) || string_range?(value) ? RangeValue.new(value, self) : new(value)
        end

        def initialize(value, type = nil)
          value = Value.string_datetime?(value) ? parse_datetime(value) :
                  Value.string_time?(value) ? parse_time(value) :
                  Value.string_date?(value) ? parse_date(value) : value
          super(value, type)
        end

        def to_s
          compile
        end

        private

        def parse_datetime(string)
          DateTime.strptime(string, DATETIME_FORMAT)
        end

        def parse_time(string)
          DateTime.strptime(string, TIME_FORMAT)
        end

        def parse_date(string)
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
