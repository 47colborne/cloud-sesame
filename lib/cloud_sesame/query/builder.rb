module CloudSesame
  module Query
    class Builder
      extend ClassSpecific
      include DSL::AppliedFilterQuery
      include DSL::BlockStyledOperators
      include DSL::InspectMethod
      include DSL::PageMethods
      include DSL::QueryMethods
      include DSL::ResponseMethods
      include DSL::ReturnMethods
      include DSL::ScopeAccessors
      include DSL::SortMethods
      include DSL::KGramPhraseMethods

      # ClassSpecific construct class callback
      #
      # after construct searchable specific builder,
      # construct searchable specific DSL::LiteralMethods,
      # and Domain::Block and include the new field accessors
      # in both builder and domain block
      # ===================================================
      after_construct do |searchable|
        @literal_methods = DSL::LiteralMethods.construct_module(searchable)
        @block_domain = Domain::Block.construct_class(searchable, callback_args: [literal_methods])
        @request = Node::Request.construct_class(searchable)

        include literal_methods
      end

      # Domain::Block getter
      def self.block_domain
        @block_domain ||= Domain::Block
      end

      # Node::Request getter
      def self.request
        @request ||= Node::Request
      end

      # DSL::LiteralMethods getter
      def self.literal_methods
        @literal_methods ||= DSL::LiteralMethods
      end

      # ===================================================

      attr_reader :context, :searchable

      def initialize(context, searchable)
        @context = context
        @searchable = searchable
      end

      def request
        @request ||= self.class.request.new context
      end

      def compile
        request.compile
      end

      private

      def _block_domain(block)
        caller = block ? block.binding.eval("self") : nil
        self.class.block_domain.new caller, _context
      end

      def _scope
        request.filter_query.root
      end

      def _context
        _scope.context
      end

      def _return
        self
      end

    end
  end
end
