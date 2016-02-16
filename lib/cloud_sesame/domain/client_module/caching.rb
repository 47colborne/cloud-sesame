require_relative './caching/base'
require_relative './caching/no_cache'
require_relative './caching/rails_cache'

module CloudSesame
	module Domain
		module ClientModule
			module Caching

				def caching_with(caching_module)
					unrecognized_caching_module if !module_defined?(caching_module)
					self.executor = module_get(caching_module)
				end

				def executor
					@executor ||= Caching::NoCache.new(@searchable) { aws_client }
				end

				def executor=(executor)
					@executor = executor.new(@searchable) { aws_client }
				end

				private

				def module_defined?(caching_module)
					ClientModule::Caching.const_defined? caching_module
				end

				def module_get(caching_module)
					ClientModule::Caching.const_get caching_module
				end

				def unrecognized_caching_module
					raise Error::Caching, "Unrecognized Caching Module"
				end

			end
		end
	end
end
