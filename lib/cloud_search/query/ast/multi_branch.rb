module CloudSearch
  module Query
    module AST
      class MultiBranch
        include ::CloudSearch::Query::DSL

        attr_reader :context

        def initialize(context, &block)
          @context = context
          instance_eval &block if block_given?
        end

        def << (*children)
          self.children.concat children
        end

        def children
          @children ||= []
        end

        def serialize_children
          children.map(&:compile).join(' ')
        end

      end
    end
  end
end
