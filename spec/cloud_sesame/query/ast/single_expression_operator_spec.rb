module CloudSesame
  module Query
    module AST
      describe SingleExpressionOperator do

        let(:context) { {} }
        let(:options) { {} }
        let(:block) { Proc.new {} }

        subject { SingleExpressionOperator.new(context, options, &block) }

        it 'should be a type of operator' do
          expect(MultiExpressionOperator.ancestors).to include(Operator)
        end

        describe '#child' do
          it 'should be nil by default' do
            expect(subject.child).to be_nil
          end
        end

        describe '#is_for' do
          it 'should forward the field and field options to it\'s child' do
            subject.child = OpenStruct.new is_for: ""
            expect(subject.child).to receive(:is_for).with(:test, :options)
            subject.is_for :test, :options
          end
        end

        describe '#is_excluded' do
          context 'when child exist' do
            it 'should call #is_excluded on it\'s child' do
              subject.child = OpenStruct.new is_excluded: ""
              expect(subject.child).to receive(:is_excluded)
              subject.is_excluded
            end
          end
          context 'when child not exist' do
            it 'should call #is_excluded on it\'s child' do
              expect(subject.child).to_not receive(:is_excluded)
              subject.is_excluded
            end
          end
        end

        describe '#<<' do
          it 'should set the object as child' do
            child = OpenStruct.new()
            expect { subject << child }.to change{ subject.child }.from(nil).to(child)
          end
        end

        describe '#compile' do
          before {
            subject.child = OpenStruct.new compile: ""
            allow(subject.child).to receive(:compile).and_return(" ")
          }
          it 'should compile it\'s child and detailed set to false' do
            expect(subject.child).to receive(:compile).with(SingleExpressionOperator::DETAILED)
            subject.compile
          end
          context 'when theres boost options' do
            it 'should include boost value in the compiled value' do
              subject.options[:boost] = 1
              expect(subject.compile).to include("boost=1")
            end
          end
          context 'when theres no boost options' do
            it 'should not include boost value in the compiled value' do
              expect(subject.compile).to_not include("boost=")
            end
          end
          context 'when theres a symbol' do
            before { SingleExpressionOperator::SYMBOL = "test_symbol"}
            it 'should include the symbol in the compiled value' do
              expect(subject.compile).to include "(test_symbol"
            end
          end
        end

      end
    end
  end
end
