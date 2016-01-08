module CloudSearch
  module Query
    module DSL

      # CLAUSE: AND
      # =========================================
      def and(&block)
        attach(Node::And.new context).instance_eval &block
        return self
      end

      alias_method :all, :and
      alias_method :and!, :and

      # CLAUSE: OR
      # =========================================
      def or(&block)
        attach(Node::Or.new context).instance_eval &block
        return self
      end

      alias_method :any, :or
      alias_method :or!, :or

      # CLAUSE: LITERAL
      # =========================================

      def literal(field, *values)
        ensure_format(values.size)
        values.each { |value| attach Node::Literal.new(field, value) }
        return self
      end

      private

      def method_missing(name, *args, &block)
        literal(name, *args) if (options = context[:fields][name])
      end

      def ensure_format(size)
        raise Error::InvalidFormat if !respond_to?(:children) && size != 1
      end

      def attach(node)
        respond_to?(:children) ? self.children << node : self.child = node
        return node
      end

    end
  end
end
