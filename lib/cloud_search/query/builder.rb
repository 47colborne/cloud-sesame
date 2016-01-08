module CloudSearch
	module Query
		class Builder

			attr_accessor :context, :searchable_class

			def initialize(default_context, searchable_class)
				@context = default_context
				@searchable_class = searchable_class
			end

			def request
				@request ||= Node::Request.new context.dup
			end

			def reset
				@request = nil
			end

			# CHAINABLE METHODS
			# =========================================

			def text(text)
				request.query.terms << text
				return self
			end

			def page(value)
				request.page.page = value.to_i
				return self
			end

			def size(value)
				request.page.size = value.to_i
				return self
			end

			def sort(hash = {})
				hash.each { |key, value| request.sort[key] = value }
				return self
			end

			def and(&block)
				node = AST::And.new context[:filter_query], &block
				request.filter_query.root.children << node

				return self
			end

			def or(&block)
				node = AST::Or.new context[:filter_query], &block
				request.filter_query.root.children << node

				return self
			end

			# ENDING METHODS
			# =========================================

			def search
				compiled = request.compile
				raise Error::MissingQuery.new("Query can not be empty!") unless compiled[:query] && !compiled[:query].empty?
				result = searchable_class.cloudsearch.client.search compiled
				reset
				result
			end

		end
	end
end
