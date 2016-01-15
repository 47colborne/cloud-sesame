module CloudSesame
  module Query
    module AST
      class CompoundArray < Array

        attr_reader :scope, :field

        def field=(field)
          parents.clear
          @field = field
        end

        def parents
          @parents ||= []
        end

        def scope_to(scope)
          @scope = scope
          return self
        end

        # SINGLE BRANCH OPERATOR
        # =======================================

        # NEAR
        # =======================================
        def near(*values)
          parents[1] = AST::Near
          insert_and_return_children values
        end

        alias_method :sloppy, :near

        # NOT
        # =======================================
        def not(*values)
          parents[0] = AST::Not
          insert_and_return_children values
        end

        alias_method :is_not, :not

        # PREFIX
        # =======================================
        def prefix(*values)
          parents[1] = AST::Prefix
          insert_and_return_children values
        end

        alias_method :start_with, :prefix
        alias_method :begin_with, :prefix

        def insert_and_return_children(values = [])
          values.each do |value|
            value.child.field = field if value.kind_of?(AST::SingleExpressionOperator)
            child = value.kind_of?(AST::SingleExpressionOperator) || value.kind_of?(AST::Literal) ? value : AST::Literal.new(field, value, options)

            current_scope = self
            parents.compact.each do |parent|
              current_scope << (node = parent.new scope.context)
              current_scope = node
            end
            current_scope << child
          end
          return self
        end

        private

        def options
          scope.context[:fields][field]
        end

      end
    end
  end
end
