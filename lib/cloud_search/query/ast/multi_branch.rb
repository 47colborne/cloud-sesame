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

        def children
          @children ||= Array.new
        end

        def compile_children
          children.map(&:compile).join(' ')
        end

      end
    end
  end
end
