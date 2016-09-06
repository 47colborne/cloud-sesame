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
              literal field, phrase(value, boost: words.size * MULTIPLIER)

              each_k_gram_combination(words) do |combination|
                terms = (words - combination).join(' ')

                val = combination.join(' ')
                boost = MULTIPLIER * combination.size

                and!(boost: boost + 2) do
                  literal field, phrase(val)
                  literal field, term(terms)
                end

                literal field, phrase(val, boost: boost)
              end

              literal field, term(value)
            end
          end

          _return != _scope ? _return : self
        end

        private

        def each_k_gram_combination(array)
          min = [array.size - 4, 1].max
          n = array.size - 1
          while n > min
            array.each_cons(n) do |combination|
              yield combination
            end

            n -= 1
          end
        end
      end
    end
  end
end

# (or
#   (phrase 'black leather jacket')
#   (and (phrase 'black leather') (term 'jacket'))
#   (phrase 'black leather')
#   (and (phrase 'leather jacket') (term 'black'))
#   (phrase 'leather jacket')
# )