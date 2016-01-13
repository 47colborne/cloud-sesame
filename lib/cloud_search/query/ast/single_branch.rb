module CloudSearch
  module Query
    module AST
      class SingleBranch

        attr_accessor :child
      	attr_reader :context

      	def initialize(context, &block)
      	  @context = context
      	  instance_eval &block if block_given?
      	end

      end
    end
  end
end
