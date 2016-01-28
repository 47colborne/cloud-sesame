module CloudSesame
	module Query
		module DSL
			module BlockMethods

				# CLAUSE: AND
				# =========================================
				def and(options = {}, &block)
					node = AST::And.new _context, options
					if block_given?
						_eval node, _scope, _return, &block
					else
						Domain::ChainingBlock.new node, _scope, _return
					end
				end

				alias_method :all,  :and
				alias_method :and!, :and

				# CLAUSE: OR
				# =========================================
				def or(options = {}, &block)
					node = AST::Or.new _context, options
					if block_given?
						_eval node, _scope, _return, &block
					else
						Domain::ChainingBlock.new node, _scope, _return
					end
				end

				alias_method :any, :or
				alias_method :or!, :or

				private

				# ACCESS CALLER'S METHODS
				# =========================================
				def method_missing(name, *args, &block)
					_caller.send(name, *args, &block)
				rescue NoMethodError
					super
				end

			end
		end
	end
end
