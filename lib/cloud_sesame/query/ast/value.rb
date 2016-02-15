module CloudSesame
  module Query
    module AST
      class Value

        RANGE_FORMAT = /\A(\[|{)(.*),(.*)(\}|\])\z/
        DIGIT_FORMAT = /\A\d+(.\d+)?\z/
        SINGLE_QUATE = /\'/
        ESCAPE_QUATE = "\\'"

        attr_reader :data

        def self.parse(value)
          return value if value.kind_of? AST::Value
          (is_a_numeric?(value) ? AST::NumericValue :
            is_a_datetime?(value) ? AST::DateValue :
            is_a_range?(value) ? AST::RangeValue :
            AST::Value).new(value)
        end

        def self.is_a_numeric?(value)
          value.is_a?(Numeric) || (value.is_a?(String) && DIGIT_FORMAT =~ value)
        end

        def self.is_a_datetime?(value)
          value.kind_of?(Date) || value.kind_of?(Time)
        end

        def self.is_a_range?(value)
          value.kind_of?(Range) || (value.is_a?(String) && RANGE_FORMAT =~ value)
        end

        def initialize(data)
          @data = data
        end

        def compile
          updated? ? recompile : @compiled
        end

        def to_s
          compile
        end

        def ==(value)
          value == data || value == compile
        end

        private

        def updated?
          @compiled_data != @data
        end

        def recompile
          @compiled_data = @data
          @compiled = escape @compiled_data
        end

        def escape(data)
          "'#{ data.gsub(SINGLE_QUATE) { ESCAPE_QUATE } }'"
        end

        def strip(string)
          string.tr(" ", "")
        end

      end
    end
  end
end
