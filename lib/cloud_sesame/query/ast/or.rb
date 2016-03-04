module CloudSesame
  module Query
    module AST
      class Or < Abstract::MultiExpressionOperator
        SYMBOL = :or
      end
    end
  end
end
