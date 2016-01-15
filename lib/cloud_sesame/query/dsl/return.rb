module CloudSesame
  module Query
    module DSL
      module Return

        def all_fields
          request.return_field.value = :all_fields
        end

        def no_fields
          request.return_field.value = :no_fields
        end

        def score
          request.return_field.value = :score
        end

      end
    end
  end
end
