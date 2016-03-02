module CloudSesame
  module Query
    module AST
      class DateValue < Value

        def to_s
          compile
        end

        def compile
          strip escape data.strftime '%FT%TZ'
        end

      end
    end
  end
end
