module CloudSesame
  module Query
    module AST
      class MultiExpressionOperator < Operator

        def children
          @children ||= create_children
        end

        def compile
          "(#{ SYMBOL  }#{ boost.compile if boost } #{ children.compile })" unless children.empty?
        end

        def <<(object)
          children << object
        end

        private

        def create_children
          array = Children.new; array.scope = self; array
        end

      end
    end
  end
end
