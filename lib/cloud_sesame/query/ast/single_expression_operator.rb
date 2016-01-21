module CloudSesame
  module Query
    module AST
      class SingleExpressionOperator < Operator
        include DSL::Base
        include DSL::BlockMethods

        DETAILED = false

        attr_accessor :child

        def is_for(field, field_options)
          child.is_for field, field_options if child
        end

        def is_excluded
          child.is_excluded if child
        end

        def <<(object)
          self.child = object
        end

        def compile(detailed = nil)
          "(#{ symbol  }#{ boost } #{ child.compile operator_detailed })" if child
        end

        def operator_detailed
          self.class::DETAILED
        end

      end
    end
  end
end
