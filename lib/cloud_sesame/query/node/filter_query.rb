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
          # root =
          # context[:defaults].each { |default| root << default } if context[:defaults]
          # root
          CloudSesame::Query::AST::Root.new context
        end

      end
    end
  end
end
