module CloudSesame
  module Query
    module DSL
      module KGramPhraseMethods
        DELIMITER = / |-/.freeze
        MULTIPLIER = 5

        def k_gram_phrase(field, value, options = {})
          if value && !value.empty?
            words = value.split(DELIMITER).compact

            or!(options) do
              literal field, phrase(value, boost: MULTIPLIER * words.size)

              each_k_gram_combination(words, options[:min]) do |combination, original|
                remaining_terms = (original - combination).join(' ')
                unique_phrase = combination.join(' ')
                k = MULTIPLIER * combination.size

                and!(boost: k + 2) do
                  literal field, phrase(unique_phrase)
                  literal field, term(remaining_terms)
                end

                literal field, phrase(unique_phrase, boost: k)
              end

              literal field, term(value)
            end
          end

          _return != _scope ? _return : self
        end

        private

        def each_k_gram_combination(array, min)
          min ||= 4
          size = array.size
          m = [size - min, 1].max
          n = size - 1
          while n > m
            array.each_cons(n) { |con| yield(con, array) }
            n -= 1
          end
        end
      end
    end
  end
end