module CloudSesame
	module Query
		module AST
			class StringValue < Abstract::Value

				SINGLE_QUATE = Regexp.new(/\'/)
        ESCAPE_QUATE = Regexp.new("\\'")

				def self.parse(value)
					new(value.is_a?(String) ? value : value.to_s) if value
				end

				private

				def recompile(value)
					super escape(value)
				end

				def escape(value)
				  "'#{ value.gsub(SINGLE_QUATE) { ESCAPE_QUATE } }'"
				end

			end
		end
	end
end
