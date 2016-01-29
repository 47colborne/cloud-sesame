module CloudSesame
	module Query
		module Domain
			class ChainingBlock

				def initialize(_orphan_node, _scope, _return)
					@_orphan_node = _orphan_node
					@_scope = _scope
					@_return = _return
				end

				# CLAUSE: NOT
				# =========================================

				def not(options = {}, &block)
					raise missing_block unless block_given?
					@_scope << (node = AST::Not.new @_scope.context, options)
					_eval @_orphan_node, node, @_return, &block
				end

				private

				def _eval(node, _scope, _return, &block)
					caller = block.binding.eval("self")
					domain = Domain::Block.new caller, _scope.context
					domain._eval node, _scope, _return, &block
				end

				def missing_block
					Error::InvalidSyntax.new("#{ orphan_node.class::SYMBOL }.not requires a block")
				end

			end
		end
	end
end
