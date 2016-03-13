module CloudSesame
  module Query
    module DSL
      module FieldAccessors
        extend ClassSpecific

        def self.__define_accessor__(name)
          define_method name do |*values, &block|
            literal name, *values, &block
          end
        end

        def literal(name, *values, &block)
          name = name.to_sym
          values << __literal_block_handler__(name, block) if block_given?
          _scope.children.field = name
          _scope.children._return = _return
          _scope.children.insert values
        end

        private

        def __literal_block_handler__(name, block)
          caller = block.binding.eval "self"
          options = _scope.context[:fields][name]
          Domain::Literal.new(name, options, caller)._eval(&block)
        end

      end
    end
  end
end
