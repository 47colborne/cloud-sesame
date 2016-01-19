module CloudSesame
  module Query
    module Node
      class Return < Abstract

        attr_accessor :fields

        def fields
          @fields ||= []
        end

        def compile
          { return: fields.join(',') } unless fields.empty?
        end

      end
    end
  end
end
