module CloudSesame
  module Query
    module AST
      class Term < SingleExpressionOperator
        DETAILED = true
        SYMBOL = :term
      end
    end
  end
end
