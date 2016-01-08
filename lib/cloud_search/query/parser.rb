module CloudSearch
  module Query
    module Parser

      # Alias Method: AND
      def all(&block)
        and! &block
      end

      def and!(&block)
        attach(node = Node::And.new(context)).instance_eval &block
        return self
      end

      # Alias Method: OR
      def any(&block)
        or! &block
      end

      def or!(&block)
        attach(node = Node::Or.new(context)).instance_eval &block
        return self
      end

      def literal(field, *values)
        ensure_format(values.size)
        values.each { |value| attach Node::Literal.new(field, value) }
        return self
      end

      private

      def method_missing(name, *args, &block)
        if (options = context[:fields][name])
          literal name, *args
        end
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
