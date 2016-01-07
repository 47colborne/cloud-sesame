require 'spec_helper'

module CloudSearch
  module Query
    describe Builder do
      let(:client) { {} }
      let(:searchable_class) { "Test" }
      subject { Builder.new(client, searchable_class) }

      describe '#define_fields' do
        it 'should create accessor for each field' do
          subject.define_fields :name
          expect(subject).to respond_to :name
        end
      end

      describe 'field accessor' do
        before { subject.define_fields :name }
        it 'should return a literal node in an array' do
          expect(subject.name "Test1").to be_kind_of Node::Literal
        end
        it 'should raise Exception if trying to pass more than one values' do
          expect{ subject.name "1", "2" }.to raise_error(Error::InvalidFormat)
        end
      end

    end
  end
end
