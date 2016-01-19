module CloudSesame
  module Query
    module DSL
      module ReturnMethods

        def return_fields(*fields)
          unless fields.empty?
            request.return_field.fields = fields
            return self
          else
            request.return_field.fields
          end
        end

        def return_no_fields
          request.return_field.fields = ['_no_fields']
          return self
        end

        def include_score
          request.return_field.fields << '_score'
          return self
        end

      end
    end
  end
end
