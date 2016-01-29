# =========================================================
# field array methods enables field array to chain
# operators after calling the field expression
# accessor
# =========================================================
module CloudSesame
	module Query
		module DSL
			module FieldArrayMethods

				# NOT
				# =======================================
				def not(*values)
					parents[1] = { klass: AST::Not, options: extract_options(values) }
				  insert values
				end

				alias_method :is_not, :not

				# NEAR
				# =======================================
				def near(*values)
					parents[0] = { klass: AST::Near, options: extract_options(values) }
				  insert values
				end

				alias_method :sloppy, :near

				# PREFIX
				# =======================================
				def prefix(*values)
				  parents[0] = { klass: AST::Prefix, options: extract_options(values) }
				  insert values
				end

				alias_method :start_with, :prefix
				alias_method :begin_with, :prefix

				def insert(values = [])
					values.each do |value|
						_scope << create_parents(build_literal(value))
					end
					parents.clear unless values.empty?
				  _return != _scope ? _return : self
				end

				private

				def extract_options(values)
					values[-1].is_a?(Hash) ? values.delete_at(-1) : {}
				end

				def create_parents(child)
					parents.compact.each do |parent|
						node = parent[:klass].new _context, parent[:options]
						node << child
						child = node
					end
					child
				end

				def build_literal(value)
					if value.kind_of?(AST::SingleExpressionOperator) || value.is_a?(AST::Literal)
						value.is_for field, _context[:fields][field]
						value
					else
						AST::Literal.new field, value, _context[:fields][field]
					end
				end

			end
		end
	end
end
