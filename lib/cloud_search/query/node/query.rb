module CloudSearch
	module Query
		module Node
			class Query < Base

				attr_accessor :terms

				def initialize(context)
					@terms = (context[:query] || "").split(' ')
					super
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
