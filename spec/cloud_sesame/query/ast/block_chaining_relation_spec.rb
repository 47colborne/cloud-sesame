module CloudSesame
  module Query
    module AST
      describe BlockChainingRelation do
        let(:context) { {} }
        let(:dsl_scope) { OpenStruct.new context: context }
        let(:dsl_return) { OpenStruct.new context: context }
        let(:orphan_node) { OpenStruct.new }
        subject { BlockChainingRelation.new dsl_scope, dsl_return, orphan_node }

        describe '#dsl_context' do
          it 'should return dsl_scope context' do
            expect(subject.dsl_scope).to receive(:context)
            subject.dsl_context
          end
        end

        describe '#dsl_return' do
          context 'when dsl return is a root node' do
            let(:dsl_scope) { Root.new(context) }
            it 'should return the root' do
              expect(subject.dsl_return).to eq dsl_return
            end
          end
          context 'when dsl return is not a root node' do
            context 'and node is passed in' do
              let(:node) { OpenStruct.new }
              it 'should return the node' do
                expect(subject.dsl_return node).to eq node
              end
            end
            context 'and node is not passed in' do
              it 'should return the node' do
                expect(subject.dsl_return).to eq dsl_return
              end
            end
          end

        end

      end
    end
  end
end
