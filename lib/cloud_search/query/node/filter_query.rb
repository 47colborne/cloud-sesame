module CloudSearch
  module Query
    module Node
      class FilterQuery < Root

        def compile
          { filter_query: child.compile } if child
        end

      end
    end
  end
end
