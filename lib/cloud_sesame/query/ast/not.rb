module CloudSesame
  module Query
    module AST
      class Not < Abstract::SingleExpressionOperator
        SYMBOL = :not

        def applied(included = true)
          child.applied !included
        end

      end
    end
  end
end
