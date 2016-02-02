module CloudSesame
  module Query
    module AST
      class SingleExpressionOperator < Operator

        DETAILED = false

        attr_accessor :child

        def is_for(field, options = {})
          child.is_for field, options if child
        end

        def is_excluded
          child.is_excluded if child
        end

        def <<(object)
          self.child = object
        end

        def compile(detailed = nil)
          if child && (compiled = child.compile operator_detailed) && !compiled.empty?
            "(#{ symbol  }#{ boost } #{ compiled })"
          end
        end

        def operator_detailed
          self.class::DETAILED
        end

      end
    end
  end
end
