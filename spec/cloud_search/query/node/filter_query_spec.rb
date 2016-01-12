require 'spec_helper'

module CloudSearch
  module Query
    module Node
      describe FilterQuery do
        subject { FilterQuery.new({}) }

        describe '#compile' do
          it 'should compile root' do
            expect(subject.root).to receive(:compile)
            subject.compile
          end
          it 'should return an hash with filter query' do
            expect(subject.compile).to include(filter_query: subject.root.compile )
          end
        end

        describe '#root' do
          it 'should instantiate and return an instance of Root' do
            expect(AST::Root).to receive(:new).with(subject.context).and_call_original
            expect(subject.root).to be_kind_of(AST::Root)
          end
        end

      end
    end
  end
end
