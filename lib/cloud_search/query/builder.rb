module CloudSearch
	module Query
		class Builder
			include DSL::Base
			include DSL::FilterQuery

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

			def inspect
				"#<CloudSearch::Query::Builder:#{ object_id } #{ request.compile }>"
			end

			# CHAINABLE METHODS
			# =========================================

			def query(string)
				request.query.query = string
				return self
			end

			def terms(*terms)
				request.query.terms.concat terms
				return self
			end

			def exclude_terms(*terms)
				request.query.terms.concat terms.map { |t| "-#{ t }" }
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

			# def and(&block)
			# 	request.filter_query.root.and &block
			# 	return self
			# end

			# def or(&block)
			# 	request.filter_query.root.or &block
			# 	return self
			# end

			# ENDING METHODS
			# =========================================

			def search
				compiled = request.compile
				raise Error::MissingQuery.new("Query can not be empty!") unless compiled[:query] && !compiled[:query].empty?
				result = searchable_class.cloudsearch.client.search compiled
				reset
				result
			end

			private

			def method_scope
				request.filter_query.root
			end

		end
	end
end
