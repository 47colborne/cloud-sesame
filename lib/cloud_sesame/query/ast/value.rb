module CloudSesame
  module Query
    module AST
      class Value

        RANGE_FORMAT = /\A[\[\{].*[\]\}]\z/
        DIGIT_FORMAT = /\A\d+(.\d+)?\z/
        SINGLE_QUATE = /\'/
        ESCAPE_QUATE = "\\'"

        attr_reader :data

        def self.create(value)
          return value if value.kind_of? Value
          return DateValue.new(value) if value.kind_of?(Date) || value.kind_of?(Time)
          return RangeValue.new(value) if value.kind_of?(Range) || value =~ RANGE_FORMAT
          return NumericValue.new(value) if value.is_a?(Numeric) || value =~ DIGIT_FORMAT
          Value.new(value)
        end

        def initialize(data)
          @data = data
        end

        def compile
          escape data
        end

        def to_s
          compile
        end

        def ==(value)
          value == data
        end

        private

        def escape(data)
          "'#{ data.gsub(SINGLE_QUATE) { ESCAPE_QUATE } }'"
        end

        def strip(string)
          string.gsub(/ /, '')
        end

      end
    end
  end
end
