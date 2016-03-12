require_relative './caching/base'
require_relative './caching/no_cache'
require_relative './caching/rails_cache'

module CloudSesame
	module Domain
		module ClientModule
			module Caching

				def caching_with(klass)
					self.executor = klass.is_a?(Class) ? klass : module_get(klass)
				end

				def executor
					@executor ||= Caching::NoCache.new(aws_client, @searchable)
				end

				def executor=(executor)
					@executor = executor.new(aws_client, @searchable)
				end

				private

				def module_get(klass)
					ClientModule::Caching.const_get klass, false
				end

			end
		end
	end
end
