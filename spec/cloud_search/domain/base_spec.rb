require 'spec_helper'

module CloudSearch
  module Domain
    describe Base do

      let(:searchable_class) { "Test" }
      subject { Base.new(searchable_class) }

      describe '#initalize' do
        it 'should set searchable class' do
          expect(subject.searchable_class).to eq "Test"
        end
        it 'should store self instace in instances list using searchable_class as key' do
          expect(Base.instances).to include("Test" => subject)
        end
      end

      describe '#define_search' do
        it 'should instance eval the block it pass in' do
          expect(subject).to receive(:test)
          subject.define_search { test }
        end
      end

      describe '#define_fields' do
        let(:fields) { [:name, :price] }
        it 'should delegate to it\'s class specific builder instance' do
          expect_any_instance_of(CloudSearch::Query::Builder).to receive(:define_fields).with(*fields)
          subject.define_fields(*fields)
        end
      end

      describe '#client' do

      end

      describe '#query' do

      end




    end
  end
end
