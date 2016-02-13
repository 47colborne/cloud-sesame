require 'cloud_sesame/domain/client_modules/caching/rails_cache'

module CloudSesame
	module Domain
		module ClientModules
			module Caching

				def caching_with(caching_module, &block)
					caching_module = "#{ caching_module }Cache"
					if ClientModules::Caching.const_defined? caching_module
						self.executor = ClientModules::Caching.const_get caching_module
					end
				end

				def fetch(aws_client, params)
					aws_client.search params
				end

				private

				def executor
					@executor ||= self
				end

				def executor=(executor)
					@executor = executor
				end

			end
		end
	end
end
