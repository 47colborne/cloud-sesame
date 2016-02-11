module CloudSesame
	module Query
		module DSL
			module ResponseMethods

				def response
					@response ||= search
				end

				# ENDING METHODS
				# =========================================

				def found
					response.hits.found
				end

				def results
					response.hits.hit
				end

				def each(&block)
					results.each &block
				end

				def map(&block)
					results.map &block
				end

				def hash_key(compiled)
					Digest::MD5.hexdigest(JSON.generate(compiled.merge(searchable: searchable.to_s)))
				end

				def search
					compiled = request.compile
					raise Error::MissingQuery.new("Query or FilterQuery can not be empty!") if !compiled[:query] || compiled[:query].empty?
					if context[:cache]
						@response = Rails.cache.fetch(hash_key(compiled)) do
							results = searchable.cloudsearch.client.search compiled
						  OpenStruct.new(status: results.status, hits: results.hits, facets: results.facets)
						end
					else
						@response = searchable.cloudsearch.client.search compiled
					end
					@response
				end

			end
		end
	end
end
