require 'spec_helper'

module CloudSesame
  module Domain
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

      describe '#[]' do
        # it 'should return an '

      end

    end
  end
end
