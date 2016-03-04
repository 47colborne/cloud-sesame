module CloudSesame
  module Query
    module AST
      module Abstract
        class MultiExpressionOperator < Operator

          def <<(object)
            children << object
          end

          def applied(included = true)
            children.map { |child| child.applied(included) }
          end

          def children
            @children ||= create_children
          end

          def compile
            if !children.empty? && (compiled = children.compile) && !compiled.empty?
              "(#{ symbol  }#{ boost } #{ compiled })"
            end
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
end
