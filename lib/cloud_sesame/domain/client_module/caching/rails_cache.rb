module CloudSesame
	module Domain
		module ClientModule
			module Caching
				class RailsCache < Base

					def initialize(client, searchable)
						ensure_environment_exists
						super
					end

					def fetch(params)
						Rails.cache.fetch(hashify(params)) do
							results = search params
							OpenStruct.new(status: results.status, hits: results.hits, facets: results.facets)
						end
					end

					private

					def hashify(params)
						searchable_params = params.merge(searchable: @searchable)
						Digest::MD5.hexdigest Marshal.dump(searchable_params)
					end

					def ensure_environment_exists
						unless RailsCache.const_defined?(:Rails)
							raise Error::Caching, "Rails environment cannot be found"
						end
					end

				end
			end
		end
	end
end
