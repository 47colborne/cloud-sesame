module CloudSesame
  module Query
    module AST
      class Or < MultiExpressionOperator
        self.symbol = :or
      end
    end
  end
end
