module CloudSesame
  module Domain
    module ClientModule
      module Caching
        class NoCache < Base

          def fetch(params)
            search params
          end

        end
      end
    end
  end
end
