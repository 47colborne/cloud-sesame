module CloudSesame
  module Query
    module AST
      class MultiExpressionOperatorChildren < Array
        include DSL::LiteralChainingMethods

        attr_accessor :_scope, :_return
        attr_reader :field

        def self.build(scope, children = nil)
          array = new(children || [])
          array._scope = scope
          array
        end

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
          map(&:compile).compact.join(' ')
        end

      end
    end
  end
end
