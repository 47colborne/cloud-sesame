module CloudSesame
  module Query
    module AST
      class FieldArray < Array
        include DSL::FieldArrayMethods

        attr_accessor :dsl_return
        attr_reader :field, :dsl_scope, :dsl_context

        def field=(field)
          parents.clear
          @field = field
        end

        def parents
          @parents ||= []
        end

        def dsl_scope=(dsl_scope)
          @dsl_context = dsl_scope.context
          @dsl_scope = dsl_scope
        end

        def compile
          map(&:compile).join(' ')
        end

      end
    end
  end
end
