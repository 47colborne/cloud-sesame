module CloudSesame
	module Query
		module Domain
			class Block

				def initialize(_caller)
					@_caller = _caller
				end

				def _evaluate(node, _scope = node, _return = node, &block)
					if block_given?
						instance_eval &block
						_scope << node
						_return
					else
						ChainingBlock.new _scope, _return, node
					end
				end

				def and(options = {}, &block)
					node = AST::And.new
					if block_given?
						_evaluate node, &block
				end

			end
		end
	end
end
