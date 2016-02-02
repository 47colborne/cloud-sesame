module CloudSesame
	module Query
		module DSL
			module BlockMethods

				# CLAUSE: AND
				# =========================================
				def and(options = {}, &block)
					_block_style_clause AST::And, options, &block
				end

				alias_method :all,  :and
				alias_method :and!, :and

				# CLAUSE: OR
				# =========================================
				def or(options = {}, &block)
					_block_style_clause AST::Or, options, &block
				end

				alias_method :any, :or
				alias_method :or!, :or

				private

				def _block_style_clause(klass, options, &block)
					node = klass.new _context, options
					if block_given?
						_block_domain(block)._eval node, _scope, _return, &block
					else
						Domain::ChainingBlock.new node, _scope, (_return if _scope.is_a?(AST::Root)), _block_domain(nil)
					end
				end

			end
		end
	end
end
