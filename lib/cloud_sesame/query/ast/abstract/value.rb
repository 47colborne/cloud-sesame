# frozen_string_literal: true

module CloudSesame
  module Query
    module AST
      module Abstract
        class Value

          # CONSTANTS
          # =====================================
          RANGE_FORMAT = Regexp.new(/\A(\[|{)(.*),(.*)(\}|\])\z/).freeze
          DIGIT_FORMAT = Regexp.new(/\A\d+(.\d+)?\z/).freeze
          DATETIME_FORMAT = Regexp.new(/\d+{4}-\d+{2}-\d+{2}T\d+{2}:\d+{2}:\d+{2}/).freeze
          TIME_FORMAT = Regexp.new(/\d+{4}-\d+{2}-\d+{2} \d+{2}:\d+{2}:\d+{2}/).freeze
          DATE_FORMAT = Regexp.new(/\d+{4}-\d+{2}-\d+{2}/).freeze

          attr_reader :value, :changed, :compiled

          # CLASS METHODS
          # =====================================

          def self.range?(value)
            value.kind_of?(Range)
          end

          def self.string_range?(value)
            value.is_a?(::String) && !!(RANGE_FORMAT =~ strip(value))
          end

          def self.numeric?(value)
            value.is_a?(::Numeric)
          end

          def self.string_numeric?(value)
            value.is_a?(::String) && !!(DIGIT_FORMAT =~ value)
          end

          def self.datetime?(value)
            value.kind_of?(::Date) || value.kind_of?(::Time)
          end

          def self.string_datetime?(value)
            value.is_a?(::String) && DATETIME_FORMAT =~ value
          end

          def self.string_time?(value)
            value.is_a?(::String) && TIME_FORMAT =~ value
          end

          def self.string_date?(value)
            value.is_a?(String) && DATE_FORMAT =~ value
          end

          # INSTANCE METHODS
          # =====================================

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
            string.to_s.tr(' ', '')
          end

          def self.strip!(string)
            string.to_s.tr!(' ', '')
          end

          def strip(string)
            string.to_s.tr(' ', '')
          end

          def strip!(string)
            string.to_s.tr!(' ', '')
          end

        end
      end
    end
  end
end
