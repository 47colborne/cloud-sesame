module CloudSesame
	module Query
		module AST
			class BlockChainingRelation
				include DSL::BlockChainingMethods

				attr_reader :orphan_node

				def initialize(dsl_scope, dsl_return, orphan_node)
					@dsl_scope = dsl_scope
					@dsl_return = dsl_return
					@orphan_node = orphan_node
				end

				def dsl_scope
					@dsl_scope
				end

				def dsl_context
					dsl_scope.context
				end

				def dsl_return(node = nil)
					@dsl_scope.is_a?(Root) || !node ? @dsl_return : node
				end

			end
		end
	end
end
