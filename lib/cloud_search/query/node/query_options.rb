# defaultOperator: 'and', 'or', 0..100%
# fields: ['text'^5, 'text_arry']
# operators

module CloudSearch
  module Query
    module Node
      class QueryOptions < Abstract

        def compile
          {}
        end

      end
    end
  end
end
