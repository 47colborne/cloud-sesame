module CloudSesame
	module Query
		module Node
			class Request < Abstract

				# CHILDREN
				# =========================================

				def query
					@query ||= Query.new(context[:query] ||= {})
				end

				def query_options
					@query_options ||= QueryOptions.new(context[:query_options] ||= {})
				end

				def query_parser
					@query_parser ||= QueryParser.new(context[:query_parser] ||= {})
				end

				def filter_query
					@filter_query ||= FilterQuery.new(context[:filter_query] ||= {})
				end

				def facet
					@facet ||= Facet.new(context[:facet] ||= {})
				end

				def page
					@page ||= Page.new(context[:page] ||= {})
				end

				def sort
					@sort ||= Sort.new(context[:sort] ||= {})
				end

				def return_field
					@return ||= Return.new(context[:return] ||= {})
				end

				# EVALUATION
				# =========================================

				def compile
					compiled = {}
					insert_q compiled
					insert_fq compiled
					insert_type compiled
					insert_rest compiled
					insert_page compiled
					compiled
				end

				private

				def insert_q(compiled)
					if (compiled_query = query.compile) && !compiled_query.empty?
						compiled.merge! compiled_query
					end
				end

				def insert_fq(compiled)
					if (compiled_filter_query = filter_query.compile)
						if compiled[:query]
							query_parser.simple
							compiled.merge! compiled_filter_query
						else
							query_parser.structured
							compiled[:query] = compiled_filter_query[:filter_query]
						end
					end
				end

				def insert_type(compiled)
					compiled[:query_parser] = query_parser.compile
					compiled
				end

				def insert_rest(compiled)
					{
						query_options: query_options,
						facet: facet,
						sort: sort,
						return: return_field
					}.each do |name, node|
						compiled_node = node.compile
						compiled[name] = compiled_node if compiled_node
					end
					compiled
				end

				def insert_page(compiled)
					compiled.merge! page.compile
				end

			end
		end
	end
end
