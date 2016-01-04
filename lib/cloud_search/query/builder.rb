module CloudSearch
	module Query
		class Builder

			def initialize(client, searchable_class)
				@client = client
				@searchable_class = searchable_class
			end

			def default_size=(value)

			end

			# CHAINABLE METHODS
			# =========================================

			def text(text)
				request.query.add text
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

			def sort(*args)
				# request.search_options.sort.add
				return self
			end

			# ENDING METHODS
			# =========================================

			def send
				@client.search request.run
			end

			# private

			def request
				@request ||= Node::Request.new
			end

		end
	end
end
