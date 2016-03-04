module CloudSesame
  module Query
    module AST
      class Term < Abstract::SingleExpressionOperator
        DETAILED = true
        SYMBOL = :term
      end
    end
  end
end
