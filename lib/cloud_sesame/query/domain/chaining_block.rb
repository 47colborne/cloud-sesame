module CloudSesame
	module Query
		module Domain
			class ChainingBlock

				attr_reader :_orphan_node, :_scope, :_return

				def initialize(_orphan_node, _scope, _return, _block_domain)
					@_orphan_node = _orphan_node
					@_scope = _scope
					@_return = _return
					@_block_domain = _block_domain
				end

				# CLAUSE: NOT
				# =========================================

				def not(options = {}, &block)
					raise missing_block unless block_given?

					node = AST::Not.new _scope.context, options
					_block_domain(block)._eval _orphan_node, node, &block
					_scope << node

					_return || node
				end

				private

				def _block_domain(block)
					@_block_domain ||= (
						caller = block.binding.eval("self")
						Domain::Block.new caller, _scope.context
					)
				end

				def missing_block
					Error::InvalidSyntax.new("#{ orphan_node.class::SYMBOL }.not requires a block")
				end

			end
		end
	end
end
