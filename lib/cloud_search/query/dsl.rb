module CloudSearch
  module Query
    module DSL

      # CLAUSE: AND
      # =========================================
      def and(&block)
        children << AST::And.new(context, &block)
        return self
      end

      alias_method :all, :and
      alias_method :and!, :and

      # CLAUSE: OR
      # =========================================
      def or(&block)
        children << AST::Or.new(context, &block)
        return self
      end

      alias_method :any, :or
      alias_method :or!, :or

      # CLAUSE: LITERAL
      # =========================================
      def literal(field, *values)
        values.each { |value| children << AST::Literal.new(field, value) }
        return self
      end

      private

      def method_missing(name, *args, &block)
        literal(name, *args) if (options = context[:fields][name])
      end

    end
  end
end
