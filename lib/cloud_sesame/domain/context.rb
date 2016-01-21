# module CloudSesame
#   module Domain
#     class Context

#       attr_reader :table

#       def initialize(table = {})
#         @table = table
#       end

#       def [](key, find_or_create = false)
#         table[key] ||= default_value(find_or_create)
#       end

#       def []=(key, value)
#         table[key] = value
#       end

#       def delete(key)
#         table.delete key
#       end

#       def each(&block)
#         table.each &block
#       end

#       def map(&block)
#         table.map &block
#       end

#       private

#       def default_value(data)
#         data != true ? data : Context.new if data
#       end

#     end
#   end
# end
