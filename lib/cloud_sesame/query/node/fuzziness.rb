module CloudSesame
  module Query
    module Node
      class Fuzziness

        EXCLUDING_TERMS = /^\-/.freeze

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

        def compile(string)
          (compiled = each_word_in(string) { |word| fuzziness(word) }).compact!
          "(#{ compiled.join('+') })"
        end

        private

        def each_word_in(string, &block)
          string.split(' ').map!(&block)
        end

        def fuzziness(word)
          if (length = word.length) >= @min_char_size && !excluding_term?(word)
            fuzziness = (length * @fuzzy_percent).round
            fuzziness = [fuzziness, @max_fuzziness].min
            "#{ word }~#{ fuzziness }"
          else
            word
          end
        end

        def excluding_term?(word)
          !!(EXCLUDING_TERMS =~ word)
        end

      end
    end
  end
end
