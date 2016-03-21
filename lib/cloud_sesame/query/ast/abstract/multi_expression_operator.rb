module CloudSesame
  module Query
    module AST
      module Abstract
        class MultiExpressionOperator < Operator

          def <<(object)
            children << object
          end

          def applied(included = true)
            children.map { |child| child.applied included }
          end

          def children
            @children ||= build_children
          end

          def compile(_ = nil)
            if !children.empty? && (compiled = children.compile) && !compiled.empty?
              "(#{ symbol  }#{ boost } #{ compiled })"
            end
          end

          private

          def build_children
            MultiExpressionOperatorChildren.build(self)
          end

        end

      end
    end
  end
end
