module CloudSesame
	module Domain
		module ClientModule
			module Caching
				class Base

					def initialize(searchable, &lazy_client)
						@searchable = searchable
						@lazy_client = lazy_client
					end

					def client
						@client ||= @lazy_client.call
					end

					def fetch(_params)
						raise Error::Caching, "Caching Module needs #fetch method and accepts params"
					end

					private

					def search(params)
						client.search params
					end

				end
			end
		end
	end
end
