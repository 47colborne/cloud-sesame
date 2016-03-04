module CloudSesame
  module Query
    module AST
      class Prefix < Abstract::SingleExpressionOperator
        DETAILED = true
				SYMBOL = :prefix
      end
    end
  end
end
