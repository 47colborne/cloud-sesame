module CloudSesame
  module Query
    module Node
      class Facet < Abstract

        def compile
          JSON.dump(context) if context && !context.empty?
        end

      end
    end
  end
end
