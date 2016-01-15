module CloudSesame
  module Query
    module DSL
      describe FilterQuery do

        class TestClass
          include Base
          include FilterQuery
          def initialize
          end
          def children
            @children ||= AST::CompoundArray.new.scope_to self
          end
          def context
            @context ||= {}
          end
        end

        subject { TestClass.new }

        describe '#and' do
          it 'should create an AND node' do
            expect(AST::And).to receive(:new).with({})
            subject.and
          end
          it 'should add the AND node to it\s children' do
            expect(AST::And).to receive(:new).with({})
            expect{ subject.and }.to change{ subject.children.size }.by(1)
          end
          it 'should return it\'s own scope' do
            expect(subject.and).to eq subject
          end
        end

        describe '#or' do
          it 'should create an OR node' do
            expect(AST::Or).to receive(:new).with({})
            subject.or
          end
          it 'should add the OR node to it\s children' do
            expect(AST::Or).to receive(:new).with({})
            expect{ subject.or }.to change{ subject.children.size }.by(1)
          end
          it 'should return it\'s own scope' do
            expect(subject.and).to eq subject
          end
        end

        describe 'included?' do
          before { subject.context[:fields] = { tags: {}, description: {} } }
          context 'when there is a field and no value' do
            it 'should return true if the request contains the field in the filter query' do
              subject.and { tags 'women' }
              expect(subject.included?(:tags)).to be_truthy
            end

            it 'should return false if the request does not contain the field in the filter query' do
              subject.and { tags.not 'women' }
              expect(subject.included?(:tags)).to be_falsey
            end

          end
          context 'when there is a field and a value' do
            it 'should return true if the request contains the field and the value in the filter query' do
              subject.and { tags("women") }
              expect(subject.included?(:tags, "women")).to be_truthy
            end

            it 'should return false if the request does not contain the field or the value in the filter query' do
              subject.and{tags('women')}
              expect(subject.included?(:tags, 'men')).to be_falsey
              expect(subject.included?(:description, 'women')).to be_falsey
            end
          end
        end

        describe 'excluded?' do
          before { subject.context[:fields] = { tags: {}, description: {} } }
          context 'when there is a field and no value' do
            it 'should return true if the request excludes the field in the filter query' do
              subject.and { tags 'women' }
              expect(subject.excluded?(:tags)).to be_falsey
            end

            it 'should return false if the request does not exclude the field in the filter query' do
              subject.and{tags.not('women')}
              expect(subject.excluded?(:tags)).to be_truthy
            end
          end

          context 'when there is a field and a value' do
            it 'should return true if the request excludes the field and the value in the filter query' do
              subject.and{tags.not('women')}
              expect(subject.excluded?(:tags, 'women')).to be_truthy
            end

            it 'should return false if the request does not exclude the field or the value in the filter query' do
              subject.and{tags('women')}
              expect(subject.excluded?(:tags, 'men')).to be_falsey
              expect(subject.excluded?(:tags, 'women')).to be_falsey
            end
          end
        end

      end
    end
  end
end
