module CloudSesame
  module Query
    module AST
      class Prefix < SingleExpressionOperator
				self.symbol = :prefix

				def compile
					child.detailed if child.kind_of?(Literal)
					super
				end
      end
    end
  end
end
