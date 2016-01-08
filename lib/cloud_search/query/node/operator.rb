module CloudSearch
  module Query
    module Node
      class Operator < Base
        include CloudSearch::Query::DSL

        def children
          @children ||= []
        end

        private

        def serialize_children
          children.map(&:compile).join(' ')
        end

      end
    end
  end
end
