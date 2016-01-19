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

        def compile
          "(#{ self.class::SYMBOL  }#{ boost } #{ child.compile self.class::DETAILED })" if child
        end

      end
    end
  end
end
