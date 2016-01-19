module CloudSesame
  module Query
    module Node
      class Fuzziness

        def initialize(&block)

          # default fuzziness
          @max_fuzziness = 3
          @min_char_size = 6
          @fuzzy_percent = 0.17

          instance_eval &block if block_given?
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
          join_by_and each_with(string) { |word| fuzziness word }
        end

        private

        def each_with(string, &block)
          string.split(' ').map &block
        end

        def fuzziness(word)
          if word.length >= @min_char_size && !excluding_term?(word)
            fuzziness = (word.length * @fuzzy_percent).round
            fuzziness = [fuzziness, @max_fuzziness].min
            "#{word}~#{fuzziness}"
          else
            word
          end
        end

        def join_by_and(args = [])
          (args = args.compact).size > 1 ? "(#{ args.join('+') })" : args[0]
        end

        def excluding_term?(word)
          !!word.match(/^\-/)
        end

      end
    end
  end
end
