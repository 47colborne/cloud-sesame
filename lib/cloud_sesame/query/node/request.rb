module CloudSesame
	module Query
		module Node
			class Request < Abstract
				extend ClassSpecific

				after_construct do |searchable|
					@query = Query.construct_class(searchable)
				end

				def self.query
					@query ||= Query
				end

				# CHILDREN
				# =========================================

				def query
					@query ||= self.class.query.new(context[:query])
				end

				def query_options
					@query_options ||= QueryOptions.new(context[:query_options])
				end

				def query_parser
					@query_parser ||= QueryParser.new(context[:query_parser])
				end

				def filter_query
					@filter_query ||= FilterQuery.new(context[:filter_query])
				end

				def facet
					@facet ||= Facet.new(context[:facet])
				end

				def page
					@page ||= Page.new(context[:page])
				end

				def sort
					@sort ||= Sort.new(context[:sort])
				end

				def return_field
					@return ||= Return.new(context[:return])
				end

				# EVALUATION
				# =========================================

				def compile
					compiled = {}
					insert_query compiled
					insert_filter_query compiled
					insert_query_parser compiled
					insert_rest compiled
					insert_page compiled
					compiled
				end

				private

				def insert_query(compiled)
					if (compiled_query = query.compile) && !compiled_query.empty?
						compiled[:query] = compiled_query
					end
				end

				def insert_filter_query(compiled)
					if (compiled_fq = filter_query.compile)
						if compiled[:query]
							query_parser.simple
							compiled[:filter_query] = compiled_fq
						else
							query_parser.structured
							compiled[:query] = compiled_fq
						end
					end
				end

				def insert_query_parser(compiled)
					compiled[:query_parser] = query_parser.compile
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
