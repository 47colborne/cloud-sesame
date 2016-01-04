module CloudSearch
	module Query
		module Node
			class Request

				# CHILDREN
				# =========================================

				def query
					@query ||= Query.new
				end

				def query_options
					@query_options ||= QueryOptions.new
				end

				def filter_query
					@filter_query ||= FilterQuery.new
				end

				def facet
					@facet ||= Facet.new
				end

				def page
					@page ||= Page.new
				end

				def search_options
					@search_options ||= SearchOptions.new
				end

				# EVALUATION
				# =========================================

				def run
					[query, page].each_with_object({}) do |node, result|
						result.merge! node.run
					end
				end

			end
		end
	end
end
