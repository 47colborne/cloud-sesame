# module CloudSesame
#   module Query
#     module DSL

#       # CLAUSE: AND
#       # =========================================
#       def and(&block)
#         filter_query.children << AST::And.new(context, &block)
#         return filter_query
#       end

#       alias_method :all,  :and
#       alias_method :and!, :and
#       alias_method :+,    :and

#       # CLAUSE: OR
#       # =========================================
#       def or(&block)
#         filter_query.children << AST::Or.new(context, &block)
#         return filter_query
#       end

#       alias_method :any, :or
#       alias_method :or!, :or

#       # CLAUSE: LITERAL
#       # =========================================
#       def literal(field, value, options = {})
#         node = AST::Literal.new(field, value, options)
#         filter_query.children << node
#         node
#       end

#       def prefix(literals)
#         literals.each { |literal| literal.options[:prefix] = true }
#         return filter_query
#       end

#       private

#       def filter_query
#         self
#       end

#       def scopes
#         filter_query.context[:scopes]
#       end

#       def method_missing(field, *values, &block)
#         if context[:fields] && (options = context[:fields][field])
#           values.map { |value| literal(field, value, options) }
#         elsif scope && (callback = scope[field])
#           filter_query.instance_exec *values, &callback
#           return filter_query
#         else
#           super
#         end
#       end

#     end
#   end
# end
