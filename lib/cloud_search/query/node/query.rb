module CloudSearch
	module Query
		module Node
			class Query < Abstract

				attr_writer :terms

				def terms
					@terms ||= (q = context[:query]) ? q.split(' ') : []
				end

				def query
					terms.map!(&:strip).join(' ')
				end

				def empty?
					terms.empty?
				end

				def compile
					{ query: query }
				end

			end
		end
	end
end
