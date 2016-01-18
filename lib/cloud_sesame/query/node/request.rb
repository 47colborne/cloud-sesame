module CloudSesame
	module Query
		module Node
			class Request < Abstract

				# CHILDREN
				# =========================================

				def query
					@query ||= Query.new(context[:query, true])
				end

				def query_options
					@query_options ||= QueryOptions.new(context[:query_options, true])
				end

				def query_parser
					@query_parser ||= QueryParser.new(context[:query_parser, true])
				end

				def filter_query
					@filter_query ||= FilterQuery.new(context[:filter_query, true])
				end

				def facet
					@facet ||= Facet.new(context[:facet, true])
				end

				def page
					@page ||= Page.new(context[:page, true])
				end

				def sort
					@sort ||= Sort.new(context[:sort, true])
				end

				def return_field
					@return ||= Return.new(context[:return, true])
				end

				# EVALUATION
				# =========================================

				def compile
					compiled = [
						query,
						query_options,
						query_parser,
						filter_query,
						facet,
						page,
						sort,
						return_field
					].each_with_object({}) do |node, compiled|
						compiled.merge!(node.compile || {})
					end

					if compiled[:filter_query].empty?
						compiled.delete(:filter_query)
					elsif compiled[:query].nil? || compiled[:query].empty?
						convert_to_structured_query(compiled)
					end

					compiled
				end

				private

				def convert_to_structured_query(compiled)
					replace(compiled, :query, :filter_query).merge! query_parser.structured.compile
				end

				def replace(hash, key1, key2)
					hash[key1] = hash.delete key2
					hash
				end

			end
		end
	end
end
