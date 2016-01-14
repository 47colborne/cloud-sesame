module CloudSesame
  module Query
    module AST
      class Near < SingleExpressionOperator
				self.symbol = :near

				def compile
					child.detailed
					super
				end

      end
    end
  end
end
