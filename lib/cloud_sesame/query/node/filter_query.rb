module CloudSesame
  module Query
    module Node
      class FilterQuery < Abstract

        def compile
          { filter_query: compiled } unless (compiled = root.compile).empty?
        end

        def root
          @root ||= CloudSesame::Query::AST::Root.new context
        end

      end
    end
  end
end
