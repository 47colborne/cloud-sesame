module CloudSesame
  module Query
    module Node
      class QueryParser < Abstract

        def type
          @type ||= (context[:query_parser] || "simple")
        end

        def simple
          @type = "simple"
        end

        def structured
          @type = "structured"
        end

        def compile
          { query_parser: type.to_s }
        end

      end
    end
  end
end
