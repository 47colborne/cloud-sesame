require "spec_helper"

module CloudSesame
  module Query
    module AST
      describe MultiBranch do
        let(:context) { {} }
        let(:proc) { Proc.new { } }
        let(:node) { MultiBranch.new(context, &proc) }

        describe '#initialize' do
          it 'should store the context' do
            expect(node.context).to eq context
          end
          it 'should accepts an block and eval it' do
            proc = Proc.new { test }
            expect_any_instance_of(MultiBranch).to receive(:test)
            MultiBranch.new(context, &proc)
          end
        end

        describe '#children' do
          it 'should instantiate an empty array' do
            expect(CompoundArray).to receive(:new).and_call_original
            node.children
          end
          it 'should return the array' do
            node.children.concat([1,2,3])
            expect(node.children).to eq [1,2,3]
          end
        end

        describe '#compile_children' do
          let(:children) {
            [Value.new('value1'),
              Value.new('value2')]
          }
          it 'should compile its children' do
            children.each do |child|
              expect(child).to receive(:compile)
            end

            node.children.concat(children)
            node.compile_children
          end

          it 'should join its compiled children with a space' do
            children.each do |child|
              expect(child).to receive(:compile).and_call_original
            end
            node.children.concat(children)
            expect(node.compile_children).to eq("'value1' 'value2'")
          end
        end

        describe 'Query DSL' do
          it 'should be included' do
            expect(node).to respond_to(:and, :or)
          end
        end

      end
    end
  end
end
