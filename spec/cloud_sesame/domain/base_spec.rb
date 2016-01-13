require 'spec_helper'

module CloudSesame
  module Domain
    describe Base do

      let(:searchable_class) { "Test" }
      subject { Base.new(searchable_class) }

      describe '#initalize' do
        it 'should set searchable class' do
          expect(subject.searchable_class).to eq "Test"
        end
      end

      describe '#field' do
      end

      describe '#client' do
      end

      describe '#query' do
      end

    end
  end
end
