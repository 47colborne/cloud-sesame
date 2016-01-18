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

      end
    end
  end
end
