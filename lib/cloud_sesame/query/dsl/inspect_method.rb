module CloudSesame
	module Query
		module DSL
			module InspectMethod

				def inspect
					string = green("#<#{ self.class }:#{ object_id }\n{")

					string << compile.map { |k, v| "#{ green(k) } => #{ yellow(v) }" }.join(",\n ")
					string << green('}')
					string
				end

				private

				def green(string)
					color(32, string)
				end

				def yellow(string)
					color(33, string)
				end

				def color(code, string)
					"\e[#{ code }m#{ string }\e[0m"
				end

			end
		end
	end
end
