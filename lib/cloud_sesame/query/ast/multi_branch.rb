module CloudSesame
  module Query
    module AST
      class MultiBranch
        include DSL::Base
        include DSL::FilterQuery
        include DSL::Scope

        attr_reader :context

        def initialize(context, &block)
          @context = context
          instance_eval &block if block_given?
        end

        def children
          @children ||= CompoundArray.new.scope_to self
        end

        def compile_children
          children.map(&:compile).join(' ')
        end

      end
    end
  end
end
