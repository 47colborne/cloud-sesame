module CloudSearch
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

				private

				def fields
					method_context[:fields]
				end

				def method_missing(field, *values, &block)
				  if fields && (options = fields[field])
				  	literal_array = LiteralArray.new
				  	literal_array.setup method_scope, field, options
				  	literal_array.concat values.map { |value| literal(field, value, options) }
						literal_array
				  else
				    super
				  end
				end

				class LiteralArray < Array

					attr_accessor :field, :options, :scope

					def setup(scope, field, options = {})
						self.scope = scope
						self.field = field
						self.options = options
					end

					def not(*values)
						values.each do |value|
							self << (node = AST::Not.new scope.context)
							scope.children << node
							node.child = AST::Literal.new field, value, options.merge(not: true)
						end
						self
					end

					def start_with(*values)
						values.each do |value|
							self << (node = AST::PrefixLiteral.new field, value, options)
							scope.children << node
						end
						self
					end

				end

			end
		end
	end
end
