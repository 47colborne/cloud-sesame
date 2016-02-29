module CloudSesame
	module Query
		module Node
			class Query < Abstract

				attr_accessor :query

				def compile
					if query && !query.empty?
						compiled = "(#{ query })"

						[context[:fuzziness], context[:sloppiness]].each do |parser|
							if parser && (parsed = parser.compile(query))
								compiled << "|" << parsed
							end
						end

						compiled
					end
				end

			end
		end
	end
end
