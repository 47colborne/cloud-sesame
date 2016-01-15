module CloudSesame
  module Query
    module Node
      class Return < Abstract

        attr_accessor :value

        def compile
          { return: format(value) } if value
        end

        private

        def format(value)
          value.to_s.gsub(/^_?/, '_')
        end

      end
    end
  end
end
