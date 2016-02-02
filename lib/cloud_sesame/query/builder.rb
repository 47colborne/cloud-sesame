module CloudSesame
	module Query
		class Builder
			include DSL::QueryMethods
			include DSL::ResponseMethods
			include DSL::BlockMethods
			include DSL::FieldAccessors
			include DSL::FilterQueryMethods
			include DSL::ScopeAccessors
			include DSL::PageMethods
			include DSL::SortMethods
			include DSL::ReturnMethods

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

			def _block_domain(block)
				if block
					caller = block.binding.eval("self")
					Domain::Block.new caller, _context
				end
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
