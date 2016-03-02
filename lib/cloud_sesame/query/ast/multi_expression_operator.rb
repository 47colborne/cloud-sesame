module CloudSesame
  module Query
    module AST
      class MultiExpressionOperator < Operator

        def children
          @children ||= create_children
        end

        def compile
          if !children.empty? && (compiled = children.compile) && !compiled.empty?
            "(#{ symbol  }#{ boost } #{ compiled })"
          end
        end

        def <<(object)
          children << object
        end

        def applied(included = true)
          children.map { |child| child.applied(included) }
        end

        private

        def create_children
          array = FieldArray.new
          array._scope = self
          array
        end

      end
    end
  end
end
