module CloudSesame
	module Query
		module Node
			class Query < Abstract

				def terms=(array)
					@terms = array
				end

				def terms
					@terms ||= (q = context[:query]) ? q.split(' ') : []
				end

				def query
					terms.map!(&:strip).join(' ')
				end

				def query=(string = '')
					@terms = string.split(' ')
				end

				def compile
					{ query: query }
				end

			end
		end
	end
end
