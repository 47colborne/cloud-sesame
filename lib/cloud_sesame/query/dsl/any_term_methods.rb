module CloudSesame
  module Query
    module DSL
      module AnyTermMethods
        DELIMITER = ' '.freeze

        def any_term(field, phrase, options = {})
          words = phrase&.split(DELIMITER)

          if words && words.length > 0
            or!(options) do
              words.map do |word|
                literal field, term(word)
              end
            end
          end

          _return != _scope ? _return : self
        end
      end
    end
  end
end
