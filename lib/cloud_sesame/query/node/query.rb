module CloudSesame
	module Query
		module Node
			class Query < Abstract

				attr_writer :query

				def query
					@query ||= context[:query]
				end

				def compile
					{ query: "(#{
							query
						})#{
							'|' << fuzziness.compile(query) if fuzziness
						}#{
							'|' << sloppiness.compile(query) if sloppiness
						}" }
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
