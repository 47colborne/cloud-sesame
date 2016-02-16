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
						compiled = ["(#{ query })"]
						compiled << fuzziness.compile(query) if fuzziness
						compiled << sloppiness.compile(query) if sloppiness
						{ query: compiled.compact.join('|') }
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
