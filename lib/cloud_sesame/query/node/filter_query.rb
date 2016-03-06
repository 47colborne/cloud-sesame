module CloudSesame
  module Query
    module Node
      class FilterQuery < Abstract

        def compile
          (compiled = root.compile) && !compiled.empty? ? compiled : nil
        end

        def root
          @root ||= CloudSesame::Query::AST::Root.new context
        end

      end
    end
  end
end
