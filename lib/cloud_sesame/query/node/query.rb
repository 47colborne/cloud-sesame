module CloudSesame
	module Query
		module Node
			class Query < Abstract

				attr_writer :query

				def query
					@query ||= context[:query]
				end

				def compile
					{ query: join_by_or(query, fuzziness, sloppiness) }
				end

				private

				def fuzziness
					context[:fuzziness] && query && !query.empty? ? context[:fuzziness].parse(query) : nil
				end

				def sloppiness
					context[:sloppiness] && query && query.include?(' ') ? "\"#{ query }\"~#{ context[:sloppiness] }" : nil
				end

				def join_by_or(*args)
					(args = args.flatten.compact).size > 1 ? "(#{ args.join('|') })" : args[0]
				end

			end
		end
	end
end
