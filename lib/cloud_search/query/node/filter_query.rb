module CloudSearch
  module Query
    module Node
      class FilterQuery < Abstract

        def compile
          { filter_query: root.compile }
        end

        def root
          @root ||= CloudSearch::Query::AST::Root.new context
        end

      end
    end
  end
end
