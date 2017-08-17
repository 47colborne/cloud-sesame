module CloudSesame
	module Query
		module AST
			class StringValue < Abstract::Value

				SINGLE_QUOTE = Regexp.new(/'/).freeze
        ESCAPE_QUOTE = "\\'".freeze

				def self.parse(value)
					new value.to_s if value
				end

				def to_ary
					compile.split(' ')
				end

				private

				def recompile(value)
					super escape value.to_s
				end

				def escape(value)
				  "'#{ value.gsub('\\', '\\\\\\\\').gsub(SINGLE_QUOTE) { ESCAPE_QUOTE } }'"
				end

			end
		end
	end
end
