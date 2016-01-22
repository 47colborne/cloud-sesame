require 'spec_helper'

module CloudSesame
  describe Context do

    describe '#initialize' do
      it 'should set default value to nil' do
        expect(subject.table).to eq({})
      end
      it 'should accept an default value' do
        context = Context.new(:default_value)
        expect(context.table).to eq(:default_value)
      end
    end

  end
end
