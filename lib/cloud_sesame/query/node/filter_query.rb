module CloudSesame
  module Query
    module Node
      class FilterQuery < Abstract

        def compile
          if (compiled = root.compile) && !compiled.empty?
            compiled
          end
        end

        def root
          @root ||= CloudSesame::Query::AST::Root.new context
        end

      end
    end
  end
end
