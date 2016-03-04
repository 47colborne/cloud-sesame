module CloudSesame
  module Query
    module AST
      class And < Abstract::MultiExpressionOperator
        SYMBOL = :and
      end
    end
  end
end
