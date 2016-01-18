module CloudSesame
	module Query
		module DSL
			module BlockMethods

				attr_accessor :orphan_node

				# CLAUSE: AND
				# =========================================
				def and(options = {}, &block)
					block_style_dsl AST::And, options, &block
				end

				alias_method :all,  :and
				alias_method :and!, :and

				# CLAUSE: OR
				# =========================================
				def or(options = {}, &block)
					block_style_dsl AST::Or, options, &block
				end

				alias_method :any, :or
				alias_method :or!, :or

				private

				def block_style_dsl(klass, options, &block)
					node = klass.new dsl_context, options, &block
					if block_given?
						dsl_scope << node
						dsl_return node
					else
						AST::BlockChainingRelation.new(dsl_scope, dsl_return, node)
					end
				end

			end
		end
	end
end
