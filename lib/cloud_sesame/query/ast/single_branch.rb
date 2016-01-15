module CloudSesame
  module Query
    module AST
      class SingleBranch

        attr_accessor :child
      	attr_reader :context

      	def initialize(context, &block)
      	  @context = context
      	  instance_eval &block if block_given?
      	end

        def child=(object)
          if object.kind_of? Literal
            (object.options[:excluded] ||= []) << object.options[:included].delete(object.value)
          end
          @child = object
        end

      end
    end
  end
end
