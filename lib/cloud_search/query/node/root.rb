module CloudSearch
  module Query
    module Node
      class Root < Base
        include ::CloudSearch::Query::Parser

        attr_accessor :child

        def initialize(context)
          @child = context[:child]
          super
        end

      end
    end
  end
end
