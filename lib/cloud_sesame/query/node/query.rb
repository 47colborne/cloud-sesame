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

						[fuzziness, sloppiness].each do |parser|
							if parser && (parsed = parser.compile(query))
								compiled << "|" << parsed
							end
						end

						{ query: compiled }
					end
				end

				private

				def fuzziness
					context[:fuzziness]
				end

				def sloppiness
					context[:sloppiness]
				end

			end
		end
	end
end
