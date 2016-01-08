module CloudSearch
  module Query
    module DSL
      module And

        # CLAUSE: AND
        # =========================================
        def and(&block)
          binding.pry
          parent << (node = Node::And.new context)
          node.instance_eval &block

          return self
        end

        alias_method :all, :and
        alias_method :and!, :and

      end
    end
  end
end
