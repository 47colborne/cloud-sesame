module CloudSesame
  module Query
    module AST
      module Abstract
        describe MultiExpressionOperator do

          let(:context) { {} }
          let(:options) { {} }
          let(:block) { Proc.new {} }

          subject { MultiExpressionOperator.new(context, options, &block) }

          it 'should be a type of operator' do
            expect(MultiExpressionOperator.ancestors).to include(Operator)
          end

          describe '#children' do
            it 'should be empty by default' do
              expect(subject.children).to be_empty
            end
            it 'should be an Field Array' do
              expect(subject.children).to be_a AST::MultiExpressionOperatorChildren
            end
          end

          describe '#compile' do
            it 'should accept one optional param' do
              expect{ subject.compile(true) }.to_not raise_error
            end

            context 'when theres children' do
              let(:child) { OpenStruct.new(compile: "compiled") }
              before { subject.children << child }

              it 'should compile to children' do
                expect(subject.children).to receive(:compile)
                subject.compile
              end

              context 'and boost options is given' do
                before { subject.options[:boost] = 2 }
                it 'should return compiled string with boost' do
                  expect(subject.compile).to eq "( boost=2 compiled)"
                end
              end
              context 'and boost options is not given' do
                it 'should return compiled string with boost' do
                  expect(subject.compile).to eq "( compiled)"
                end
              end
            end
            context 'when theres no children' do
              it 'should return nothing' do
                expect(subject.compile).to eq nil
              end
            end
          end

          describe '#<<' do
            it 'should push object into the children' do
              object = :hello
              expect(subject.children).to receive(:<<).with(object)
              subject << object
            end
          end

        end
      end
    end
  end
end
