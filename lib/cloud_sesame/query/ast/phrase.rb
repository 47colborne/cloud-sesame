module CloudSesame
  module Query
    module AST
      class Phrase < SingleExpressionOperator
				self.symbol = :phrase

				def compile
					child.detailed if child.kind_of?(Literal)
					super
				end
      end
    end
  end
end
