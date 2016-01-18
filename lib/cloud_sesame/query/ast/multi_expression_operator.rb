module CloudSesame
  module Query
    module AST
      class MultiExpressionOperator < Operator
        include DSL::Base
        include DSL::BlockMethods
        include DSL::FieldMethods
        include DSL::FilterQueryMethods
        include DSL::OperatorMethods
        include DSL::ScopeMethods
        include DSL::ValueMethods

        def children
          @children ||= create_children
        end

        def compile
          "(#{ self.class::SYMBOL  }#{ boost } #{ children.compile })" unless children.empty?
        end

        def <<(object)
          children << object
        end

        def is_excluded
          children.map(&:is_excluded)
        end

        private

        def create_children
          array = FieldArray.new
          array.dsl_scope = dsl_scope
          array
        end

      end
    end
  end
end
