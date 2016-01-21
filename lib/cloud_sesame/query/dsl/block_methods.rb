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
					node = klass.new dsl_context, options
					if block_given?
						extract_caller_from block if on_root_level?
						node.instance_eval &block
						dsl_scope << node
						dsl_return node
					else
						chaining_relation_for(node)
					end
				end

				def chaining_relation_for(node)
					AST::BlockChainingRelation.new(dsl_scope, dsl_return, node)
				end

				def on_root_level?
					dsl_scope.is_a?(AST::Root)
				end

				def extract_caller_from(block)
					dsl_context[:caller] = block.binding.eval "self"
				end

				def method_missing(name, *args, &block)
					dsl_caller ? dsl_caller.send(name, *args, &block) : super
				end

			end
		end
	end
end
