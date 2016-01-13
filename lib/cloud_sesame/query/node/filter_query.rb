module CloudSesame
  module Query
    module Node
      class FilterQuery < Abstract

        def compile
          { filter_query: root.compile }
        end

        def root
          @root ||= CloudSesame::Query::AST::Root.new context
        end

      end
    end
  end
end
