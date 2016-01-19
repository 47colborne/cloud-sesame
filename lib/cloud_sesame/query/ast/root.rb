module CloudSesame
  module Query
    module AST
      class Root < MultiExpressionOperator
        SYMBOL = :and # default operator for root

        def compile
          more_than_one_child? ? super : children.compile
        end

        def more_than_one_child?
          children.size > 1
        end

        private

        def create_children
          array = FieldArray.new(context[:defaults] || [])
          array.dsl_scope = dsl_scope
          array
        end

      end
    end
  end
end
