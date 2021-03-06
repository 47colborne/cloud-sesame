module ClassSpecific

  def construct_class(klass, callback_args: [])
    __constructor__(klass, callback_args) { |name| __define_subclass__ name, self }
  end

  def construct_module(klass, callback_args: [])
    __constructor__(klass, callback_args) { |name| __define_submodule__ name, self }
  end

  def after_construct(&block)
    @__construct_callback__ = block
  end

  private

  def __constructor__(klass, callback_args)
    return self if !(name = __get_constant_name__(klass))
    return const_get name, false  if const_defined? name.to_sym, false

    constant = yield name
    __invoke_callback__(constant, klass, *callback_args) if @__construct_callback__
    constant
  end

  def __invoke_callback__(constant, klass, *args)
    eval_method = constant.is_a?(Class) ? :class_exec : :module_exec
    constant.send(eval_method, klass, *args, &@__construct_callback__)
  end

  def __define_subclass__(name, parent)
    parent.const_set(name, Class.new(parent))
  end

  def __define_submodule__(name, parent)
    parent.const_set(name, parent.clone)
  end

  def __get_constant_name__(constant)
    (name = constant.to_s) ? name.slice(/(?=\:\:)?\w+$/) : nil
  end

end
