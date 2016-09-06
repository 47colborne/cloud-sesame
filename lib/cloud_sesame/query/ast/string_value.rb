module CloudSesame
	module Query
		module AST
			class StringValue < Abstract::Value

				SINGLE_QUATE = Regexp.new(/\'/).freeze
        ESCAPE_QUATE = "\\'".freeze

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
				  "'#{ value.gsub(SINGLE_QUATE) { ESCAPE_QUATE } }'"
				end

			end
		end
	end
end
