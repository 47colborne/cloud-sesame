class LazyObject < BasicObject

	def initialize(&callable)
		@callable = callable
	end

	def __target_object__
		@__target_object__ ||= @callable.call
	end

  def ==(object)
    __target_object__ == object
  end

	def method_missing(method_name, *args, &block)
		__target_object__.send(method_name, *args, &block)
	end

end
