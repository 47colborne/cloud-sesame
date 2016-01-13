module CloudSesame
	module Query
		module DSL
			module Literal

				# CLAUSE: LITERAL
				# =========================================
				def literal(field, value, options = {})
				  node = AST::Literal.new(field, value, options)
				  method_scope.children << node
				  node
				end

				def date(date_object)
					strip date_object.strftime('%FT%TZ')
				end

				def strip(string)
					string.gsub(/ /, '')
				end

				private

				def fields
					method_context[:fields]
				end

				def method_missing(field, *values, &block)
				  if fields && (options = fields[field])
				  	method_scope.children.field = field
				  	insert_children(values)
				  	method_scope.children
				  else
				    super
				  end
				end

			end
		end
	end
end
