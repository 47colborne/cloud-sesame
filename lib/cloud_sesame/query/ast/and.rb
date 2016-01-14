module CloudSesame
  module Query
    module AST
      class And < MultiExpressionOperator
        self.symbol = :and
      end
    end
  end
end
