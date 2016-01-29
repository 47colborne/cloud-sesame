module CloudSesame
  module Query
    module AST
      class FieldArray < Array
        include DSL::FieldArrayMethods

        attr_accessor :_scope, :_return
        attr_reader :field

        def field=(field)
          parents.clear
          @field = field
        end

        def parents
          @parents ||= []
        end

        def _context
          _scope && _scope.context
        end

        def compile
          map(&:compile).join(' ')
        end

      end
    end
  end
end
