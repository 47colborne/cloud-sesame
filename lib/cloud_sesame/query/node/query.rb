module CloudSesame
	module Query
		module Node
			class Query < Abstract

				attr_writer :query

				def query
					@query ||= context[:query]
				end

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
