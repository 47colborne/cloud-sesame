require "spec_helper"

module CloudSearch
  module Query
    module AST
      describe Root do

        let(:root) { Root.new({}) }

        describe '#compile' do
          before { root.children.concat(children) }

          context 'when it has multiple children' do
            let(:children) {
              [Literal.new(:tags, "flash_deal"),
                Literal.new(:tags, "sales")]
            }
            it 'should inject an default operator' do
              expect(root.default).to receive(:compile)
              root.compile
              expect(root.default.children).to eq children
            end
          end
          context 'when it has 1 child' do
            let(:children) {
              [Literal.new(:tags, "flash_deal")]
            }
            it 'should compile the child' do
              expect(root).to receive(:compile_children)
              root.compile
            end
          end
          context 'when it has no children' do
            let(:children) { [] }
            it 'should compile the child' do
              expect(root).to receive(:compile_children)
              root.compile
            end
          end
        end

        describe '#default' do
          it 'should instantiate and return an instance of And' do
            expect(And).to receive(:new).and_call_original
            expect(root.default).to be_kind_of(And)
          end
        end

      end
    end
  end
end
