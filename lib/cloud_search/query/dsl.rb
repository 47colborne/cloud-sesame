module CloudSearch
  module Query
    module DSL

      # CLAUSE: AND
      # =========================================
      def and(&block)
        children << AST::And.new(context, &block)
        return self
      end

      alias_method :all,  :and
      alias_method :and!, :and
      alias_method :+,    :and

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
      def literal(field, value, options = {})
        node = AST::Literal.new(field, value, options)
        self.children << node
        node
      end

      def prefix(literals)
        literals.each { |literal| literal.options[:prefix] = true }
        return self
      end

      private

      def method_missing(field, *values, &block)
        if context[:fields] && (options = context[:fields][field])
          values.map { |value| literal(field, value, options) }
        elsif context[:scope] && (callback = context[:scope][field])
          proc = Proc.new { callback.call }
          self.instance_eval &proc
          binding.pry
        else
          super
        end
      end

      def trigger_callback(callback)

      end

    end
  end
end
