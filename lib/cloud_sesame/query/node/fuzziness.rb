module CloudSesame
  module Query
    module Node
      class Fuzziness

        def initialize(&block)

          # default fuzziness
          @max_fuzziness = 3
          @min_char_size = 6
          @fuzzy_percent = 0.17

          instance_eval(&block) if block_given?
        end

        def max_fuzziness(int)
          @max_fuzziness = int.to_i
        end

        def min_char_size(int)
          @min_char_size = int.to_i
        end

        def fuzzy_percent(float)
          @fuzzy_percent = float.to_f
        end

        def parse(string)
          string.split(' ').map { |word| fuzziness word }
        end

        private

        def fuzziness(word)
          if word.length >= @min_char_size && !excluding_term?(word)
            fuzziness = (word.length * @fuzzy_percent).round
            fuzziness = [fuzziness, @max_fuzziness].min
            "#{word}~#{fuzziness}"
          else
            word
          end
        end

        def excluding_term?(word)
          !!word.match(/^\-/)
        end

      end
    end
  end
end
