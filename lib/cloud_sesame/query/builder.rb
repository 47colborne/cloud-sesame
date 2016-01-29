module CloudSesame
	module Query
		class Builder
			include DSL::PageMethods
			include DSL::QueryMethods
			include DSL::ReturnMethods
			include DSL::SortMethods
			include DSL::ResponseMethods

			# # Filter Query DSL
			include DSL::BlockMethods
			include DSL::FieldAccessors
			include DSL::FilterQueryMethods
			include DSL::ScopeAccessors

			attr_reader :context

			def initialize(context, searchable)
				@context = Context.new.duplicate context
				@searchable = searchable
			end

			def request
				@request ||= Node::Request.new context
			end

			def compile
				request.compile
			end

			def inspect
				"#<#{ self.class }:#{ object_id } #{ compile }>"
			end

			private

			def _eval(node, _scope, _return, &block)
				caller = block.binding.eval("self")
				domain = Domain::Block.new caller, _context
				domain._eval node, _scope, _return, &block
			end

			def _scope
				request.filter_query.root
			end

			def _context
				_scope.context
			end

			def _return
				self
			end

		end
	end
end
