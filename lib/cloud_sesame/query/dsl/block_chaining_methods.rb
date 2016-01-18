module CloudSesame
	module Query
		module DSL
			module BlockChainingMethods

				# CLAUSE: NOT
				# =========================================
				def not(options = {}, &block)
					raise missing_block unless block_given?
					node = AST::Not.new(dsl_context, options)
					(node << orphan_node).evaluate &block
					dsl_scope << node
				  dsl_return node
				end

				private

				def missing_block
					Error::InvalidSyntax.new("#{ orphan_node.class::SYMBOL }.not requires a block")
				end

			end
		end
	end
end
