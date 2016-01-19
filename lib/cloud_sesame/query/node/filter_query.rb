module CloudSesame
  module Query
    module Node
      class FilterQuery < Abstract

        def compile
          { filter_query: root.compile }
        end

        def root
          @root ||= create_root_with_default_values
        end

        private

        def create_root_with_default_values
          root = CloudSesame::Query::AST::Root.new context
          context[:fields].each do |field, options|
            if options && (block = options[:default])
              value = root.instance_exec &block
              root << AST::Literal.new(field, value, options)
            end
          end if context[:fields]
          root
        end

      end
    end
  end
end
