module CloudSesame
  module Query
    module Node
      class QueryParser < Abstract

        def type
          @type ||= "simple"
        end

        def simple
          @type = "simple"
        end

        def structured
          @type = "structured"
        end

        def compile
          type.to_s
        end

      end
    end
  end
end
