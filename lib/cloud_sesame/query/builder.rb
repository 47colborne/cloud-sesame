module CloudSesame
	module Query
		class Builder
			extend SearchableSpecific
			include DSL::QueryMethods
			include DSL::ResponseMethods
			include DSL::BlockStyledOperators
			include DSL::FieldAccessors
			include DSL::ScopeAccessors
			include DSL::AppliedFilterQuery
			include DSL::PageMethods
			include DSL::SortMethods
			include DSL::ReturnMethods

			after_construct do |klass, searchable|
				self.include DSL::FieldAccessors.construct_module(searchable)
			end

			attr_reader :context, :searchable

			def initialize(context, searchable)
				@context = context
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
