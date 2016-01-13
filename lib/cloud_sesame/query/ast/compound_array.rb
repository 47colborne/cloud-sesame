module CloudSesame
  module Query
    module AST
      class CompoundArray < Array
        # include Range

        attr_accessor :field, :scope,
                      :parent, :literal

        def set_scope(scope)
          self.scope = scope
          return self
        end

        # SINGLE BRANCH OPERATOR
        # =======================================
        def not(*values)
          self.parent = AST::Not
          self.literal = AST::Literal
          insert_children(values)
          return self
        end

        alias_method :is_not, :not

        # PREFIX LITERAL
        # =======================================
        def prefix(*values)
          self.literal = AST::PrefixLiteral
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

        private

        def options
          scope.context[:fields][field]
        end

        def insert_children(values = [])
          values.each do |value|
            if parent
              self << (node = parent.new scope.context)
              node.child = literal.new(field, value, options)
            else
              self << literal.new(field, value, options)
            end
          end
        end

      end
    end
  end
end
