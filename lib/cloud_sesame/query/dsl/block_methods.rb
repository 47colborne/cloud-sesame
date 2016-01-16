module CloudSesame
	module Query
		module DSL
			module BlockMethods

				# CLAUSE: AND
				# =========================================
				def and(options = {}, &block)
				  scope << AST::And.new(scope, options, &block)
				  scope_return
				end

				alias_method :all,  :and
				alias_method :and!, :and

				# CLAUSE: OR
				# =========================================
				def or(options = {}, &block)
				  scope << AST::Or.new(scope, options, &block)
				  scope_return
				end

				alias_method :any, :or
				alias_method :or!, :or

				# CLAUSE: NOT
				# =========================================
				def not(options = {}, &block)
				  scope << AST::Not.new(scope, options, &block)
				  scope_return
				end

				alias_method :not!, :not

			end
		end
	end
end
