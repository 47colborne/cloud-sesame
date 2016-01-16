module CloudSesame
	module Query
		module DSL
			module ChainingMethods

				# CLAUSE: AND
				# =========================================


				# CLAUSE: OR
				# =========================================

				# CLAUSE: NOT
				# =========================================
				def not(*values, &block)
					options = extract_options values
				  scope << (node = AST::Not.new(scope, options, &block))
				  scope_return node
				end

				alias_method :not!, :not

				private

				def extract_options!(values)
					values.last.is_a?(Hash) ? values.delete_at(-1) : {}
				end

			end
		end
	end
end
