module CloudSesame
  module Query
    module AST
      class Near < SingleExpressionOperator
				self.symbol = :near

				def compile
					child.detailed if child.kind_of?(Literal)
          "(#{ self.class.symbol  }#{ compile_boost }#{ compile_distance } #{ child.compile })" if child
				end

        def distance(value)
          @distance = value.to_i
          return self
        end

        def compile_distance
          " distance=#{ @distance }" if @distance
        end

      end
    end
  end
end
