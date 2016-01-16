module CloudSesame
  module Query
    module AST
      class Operator
        SYMBOL = nil

        attr_reader :context

        def initialize(context, options = {}, &block)
          @context = context
          @options = options
          instance_eval &block if block_given?
        end

        def boost
          options[:boost]
        end

        def boost=(value)
          options[:boost] = Boost.new value
        end

      end
    end
  end
end
