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

				def search
					compiled = request.compile
					raise Error::MissingQuery.new("Query or FilterQuery can not be empty!") if !compiled[:query] || compiled[:query].empty?
					@response = searchable.cloudsearch.client.search compiled
				end

			end
		end
	end
end
