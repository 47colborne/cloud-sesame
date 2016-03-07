require 'spec_helper'

module CloudSesame
  module Query
    module Node
      describe FilterQuery do
        subject { FilterQuery.new({}) }

        describe '#compile' do
          it 'should compile root' do
            expect(subject.root).to receive(:compile)
            subject.compile
          end
          context 'when compiled value is nil' do
            it 'should return nil' do
              expect(subject.compile).to be_nil
            end
          end
          context 'when compiled value is empty' do
            it 'should return nil' do
              expect(subject.compile).to be_nil
            end
          end
          context 'when compiled value is not empty' do
            let(:value) { "compiled value" }
            it 'should return the compiled value' do
              allow(subject.root).to receive(:compile).and_return(value)
              expect(subject.compile).to eq value
            end
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
