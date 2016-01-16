module CloudSesame
  module Query
    module AST
      class MultiExpressionOperator < Operator

        def children
          (@children ||= Children.new).scope = self
          @children
        end

        def compile
          "(#{ SYMBOL  }#{ boost.compile if boost } #{ children.compile })" unless children.empty?
        end

      end
    end
  end
end
