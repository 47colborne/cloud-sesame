module CloudSesame
  module Query
    module AST
      class CompoundArray < Array
        # include Range

        attr_accessor :scope, :parent, :literal
        attr_reader :field

        def field=(field)
          self.parent = nil
          @field = field
        end

        def set_scope(scope)
          self.scope = scope
          return self
        end

        # SINGLE BRANCH OPERATOR
        # =======================================
        def not(*values)
          self.parent = AST::Not
          insert_children(values)
          return self
        end

        alias_method :is_not, :not

        # PREFIX LITERAL
        # =======================================
        def prefix(*values)
          self.parent = AST::Prefix
          insert_children(values)
          return self
        end

        alias_method :start_with, :prefix
        alias_method :begin_with, :prefix

        # RANGE LITERAL
        # =======================================
        # def range
        #   self.literal = AST::PrefixLiteral
        #   insert_children(values)
        #   return self
        # end

        # alias_method :start_with, :prefix

        def insert_children(values = [])
          values.each do |value|
            if parent
              self << (node = parent.new scope.context)
              node.child = AST::Literal.new(field, value, options)
            else
              self << AST::Literal.new(field, value, options)
            end
          end
        end

        private

        def options
          scope.context[:fields][field]
        end

      end
    end
  end
end
