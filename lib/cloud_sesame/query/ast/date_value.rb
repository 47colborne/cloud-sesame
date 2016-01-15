module CloudSesame
  module Query
    module AST
      class DateValue < Value

        def initialize(data)
          @data = data
        end

        def compile
          strip escape @data.strftime('%FT%TZ')
        end

      end
    end
  end
end
