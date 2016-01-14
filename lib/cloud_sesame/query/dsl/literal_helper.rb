module CloudSesame
	module Query
		module DSL
			module LiteralHelper

				def d(date_object)
					strip date_object.strftime('%FT%TZ')
				end

				def strip(string)
					string.gsub(/ /, '')
				end

			end
		end
	end
end
