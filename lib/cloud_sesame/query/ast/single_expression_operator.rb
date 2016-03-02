module CloudSesame
  module Query
    module AST
      class SingleExpressionOperator < Operator

        DETAILED = false

        attr_accessor :child

        def <<(object)
          self.child = object
        end

        def applied(included = true)
          child.applied(included)
        end

        def compile(_detailed = nil)
          if child && (compiled = child.compile operator_detailed) && !compiled.empty?
            "(#{ symbol  }#{ boost } #{ compiled })"
          end
        end

        def is_for(field, options = {})
          child.is_for field, options if child
        end

        private

        def operator_detailed
          self.class::DETAILED
        end

      end
    end
  end
end
