describe ClassSpecific do

  class SearchableClass; end

  let(:searchable) { :SearchableClass }

  describe '.construct_class' do
    let(:specific_class) { SearchableClass }
    let(:klass) { Class.new { extend ClassSpecific } }

    context 'when sub-class has not being defined previously' do
      context 'and specific class passed in has a constant name' do
        it 'should define a sub-class under the extended class' do
          expect{ klass.construct_class(specific_class) }.to change{ klass.constants.size }.by(1)
        end
        it 'should name the sub-class after the class passed in' do
          expect{ klass.construct_class(specific_class) }.to change{ klass.constants }.by([searchable])
        end
      end

      context 'and specific class passed in does not have constant name' do
        let(:specific_class) { Class.new }
        it 'should not define a sub-class under the extended class' do
          expect{ klass.construct_class(specific_class) }.to_not change{ klass.constants.size }
        end
      end

      context 'and callback is given' do
        context 'and callback args is not given' do
          it 'should invoke callback after construct' do
            expect do |b|
              klass.after_construct(&b)
              klass.construct_class(specific_class)
            end.to yield_with_args(specific_class)
          end
        end
        context 'and callback is not given' do
          let(:callback_args) { [1, 2, 3] }
          it 'should invoke callback and yield callback args after construct' do
            expect do |b|
              klass.after_construct(&b)
              klass.construct_class(specific_class, callback_args: callback_args)
            end.to yield_with_args(specific_class, *callback_args)
          end
        end
      end

    end

    context 'when sub-class has being defined previously' do
      it 'should not define a sub-class again' do
        klass.construct_class(specific_class)
        expect(Class).to_not receive(:new).with(klass)
        expect{ klass.construct_class(specific_class) }.to_not change{ klass.constants.size }
      end
      it 'should not invoke callback twice' do
        expect do |b|
          klass.after_construct(&b)
          klass.construct_class(specific_class)
          klass.construct_class(specific_class)
        end.to yield_control.exactly(1).times
      end
    end

  end

  describe '.construct_module' do
    let(:specific_class) { SearchableClass }
    let(:custom_module) { Module.new { extend ClassSpecific } }

    context 'when sub-class has not being defined previously' do
      context 'and specific class passed in has a constant name' do
        it 'should define a sub-class under the extended class' do
          expect{ custom_module.construct_module(specific_class) }.to change{ custom_module.constants.size }.by(1)
        end
        it 'should name the sub-class after the class passed in' do
          expect{ custom_module.construct_module(specific_class) }.to change{ custom_module.constants }.by([searchable])
        end
      end

      context 'and specific class passed in does not have constant name' do
        let(:specific_class) { Class.new }
        it 'should not define a sub-class under the extended class' do
          expect{ custom_module.construct_module(specific_class) }.to_not change{ custom_module.constants.size }
        end
      end

      context 'and callback is given' do
        context 'and callback args is not given' do
          it 'should invoke callback after construct' do
            expect do |b|
              custom_module.after_construct(&b)
              custom_module.construct_module(specific_class)
            end.to yield_with_args(specific_class)
          end
        end
        context 'and callback is not given' do
          let(:callback_args) { [1, 2, 3] }
          it 'should invoke callback and yield callback args after construct' do
            expect do |b|
              custom_module.after_construct(&b)
              custom_module.construct_module(specific_class, callback_args: callback_args)
            end.to yield_with_args(specific_class, *callback_args)
          end
        end
      end

    end

    context 'when sub-class has being defined previously' do
      it 'should not define a sub-class again' do
        custom_module.construct_module(specific_class)
        expect(Module).to_not receive(:new).with(custom_module)
        expect{ custom_module.construct_module(specific_class) }.to_not change{ custom_module.constants.size }
      end
      it 'should not invoke callback twice' do
        expect do |b|
          custom_module.after_construct(&b)
          custom_module.construct_module(specific_class)
          custom_module.construct_module(specific_class)
        end.to yield_control.exactly(1).times
      end
    end
  end

  describe '.after_construct' do
    let(:specific_class) { SearchableClass }
    let(:klass) { Class.new { extend ClassSpecific } }
    let(:block) { Proc.new {} }
    it 'should store the block as __construct_callback__' do
      expect{ klass.after_construct(&block) }.to change{ klass.instance_variable_get(:@__construct_callback__) }.from(nil).to(block)
    end
  end

end
