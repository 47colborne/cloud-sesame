module CloudSesame
  module Query
    module AST
      module Abstract
        class Value

          RANGE_FORMAT = Regexp.new(/\A(\[|{)(.*),(.*)(\}|\])\z/).freeze
          DIGIT_FORMAT = Regexp.new(/\A\d+(.\d+)?\z/).freeze

          attr_reader :value, :changed, :compiled

          def self.range?(value)
            value.kind_of?(Range)
          end

          def self.string_range?(value)
            RANGE_FORMAT =~ strip(value)
          end

          def self.numeric?(value)
            value.is_a?(Numeric)
          end

          def self.string_numeric?(value)
            DIGIT_FORMAT =~ value.to_s
          end

          def self.datetime?(value)
            value.kind_of?(Date) || value.kind_of?(Time)
          end

          def initialize(value, type = nil)
            self.value = value
            @type = type
          end

          def value=(value)
            unless @value == value
              @changed = true
              @value = value
            end
          end

          def compile
            changed ? recompile(value) : @compiled
          end

          def to_s
            value.to_s
          end

          def ==(value)
            (value.respond_to?(:compile) && compile == value.compile) ||
            @value == value ||
            compile == value
          end

          private

          def recompile(value)
            @changed = false
            @compiled = value
          end

          # Private Helper Methods
          # ===============================================

          def self.strip(string)
            string.to_s.tr(' '.freeze, ''.freeze)
          end

          def self.strip!(string)
            string.to_s.tr!(' '.freeze, ''.freeze)
          end

          def strip(string)
            string.to_s.tr(' '.freeze, ''.freeze)
          end

          def strip!(string)
            string.to_s.tr!(' '.freeze, ''.freeze)
          end

        end
      end
    end
  end
end
