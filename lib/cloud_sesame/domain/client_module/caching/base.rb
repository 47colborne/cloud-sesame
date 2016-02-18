module CloudSesame
	module Domain
		module ClientModule
			module Caching
				class Base

					def initialize(client, searchable)
						@client = client
						@searchable = searchable
					end

					def fetch(_params)
						raise Error::Caching, "Caching Module needs #fetch method and accepts params"
					end

					private

					def search(params)
						@client.search params
					end

				end
			end
		end
	end
end
