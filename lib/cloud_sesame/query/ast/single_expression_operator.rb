module CloudSesame
  module Query
    module AST
      class SingleExpressionOperator < Operator
        DETAILED = false

        attr_accessor :child

        # def child=(object)
        #   if object.kind_of? Literal
        #     (object.options[:excluded] ||= []) << object.options[:included].delete(object.value)
        #   end
        #   @child = object
        # end

        def <<(object)
          self.child = object
        end

        def compile
          "(#{ SYMBOL  }#{ boost.compile if boost } #{ child.compile DETAILED })" if child
        end

      end
    end
  end
end
