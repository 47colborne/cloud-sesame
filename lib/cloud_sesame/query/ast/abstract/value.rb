module CloudSesame
	module Query
		module AST
			module Abstract
				class Value

					RANGE_FORMAT = /\A(\[|{)(.*),(.*)(\}|\])\z/
					DIGIT_FORMAT = /\A\d+(.\d+)?\z/

					attr_reader :value, :changed, :compiled

					def self.range?(value)
						value.kind_of?(Range)
					end

					def self.string_range?(value)
						value.is_a?(String) && RANGE_FORMAT =~ value.tr(' ', '')
					end

					def self.numeric?(value)
						value.is_a?(Numeric)
					end

					def self.string_numeric?(value)
						value.is_a?(String) && DIGIT_FORMAT =~ value
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
						(value.kind_of?(Abstract::Value) &&
							compile == value.compile) ||
						@value == value ||
						compile == value
					end

					private

					def recompile(value)
						@changed = false
						@compiled = value
					end

				end
			end
		end
	end
end
