module CloudSesame
	module Query
		module Node
			class Query < Abstract

				attr_writer :query

				def query
					@query ||= context[:query]
				end

				def compile
					compiled = [query]
					compiled << fuzziness if context[:fuzziness]
					compiled << sloppiness if context[:sloppiness]
					{ query: join_by('|', compiled) }
				end

				private

				def fuzziness
					join_by('+', context[:fuzziness].parse(query)) if context[:fuzziness] && query && !query.empty?
				end

				def sloppiness
					"\"#{ query }\"~#{ context[:sloppiness] }" if context[:sloppiness] && query && query.include?(' ')
				end

				def join_by(symbol, array)
					(array = array.compact).size > 1 ? "(#{ array.join(symbol) })" : array[0]
				end

			end
		end
	end
end
