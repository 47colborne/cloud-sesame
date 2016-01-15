module CloudSesame
  module Query
    module AST
      class Prefix < SingleExpressionOperator
				self.symbol = :prefix

				def compile
					child.detailed
					super
				end
      end
    end
  end
end
