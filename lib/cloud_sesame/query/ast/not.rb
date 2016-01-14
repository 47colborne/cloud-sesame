module CloudSesame
  module Query
    module AST
      class Not < SingleExpressionOperator
				self.symbol = :not
      end
    end
  end
end
