module CloudSesame
	module Query
		module Domain
			class Block
				extend ClassSpecific
				include DSL::AppliedFilterQuery
				include DSL::BlockStyledOperators
        include DSL::Operators
        include DSL::RangeHelper
        include DSL::ScopeAccessors
        include DSL::BindCaller
        include DSL::KGramPhraseMethods

        after_construct { |_, field_accessor| include field_accessor }

				attr_reader :_caller, :_context, :_scopes

				def initialize(_caller, _context)
					self._caller = _caller
					@_context = _context
					@_scopes = []
				end

				def _eval(node, _scope, _return = _scope, &block)
					_scopes.push node

					# must build the subtree before push (<<) to it's
					# parents (_scope) in order for the parent properly
					# propagate message down to all the children.
					# ===============================================
					instance_eval(&block)
					_scope << node

					_scopes.pop
					_scope.is_a?(AST::Root) ? _return : node
				end

				def _scope
					_scopes[-1]
				end

				def _return
					_scope
				end

				def _block_domain(_block)
					self
				end

			end
		end
	end
end
