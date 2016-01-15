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
            @children ||= AST::CompoundArray.new.set_scope(self)
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

        describe 'literal' do

          it 'should create a literal node' do
            expect(AST::Literal).to receive(:new).with('description', '123', Hash)
            subject.literal('description', '123')
          end
          it 'should add the literal node to it\'s children' do
            expect{ subject.literal('description', '123') }.to change{ subject.children.size }.by(1)
          end
          it 'should return the literal node' do
            expect(subject.literal('description', '123')).to be_kind_of(AST::Literal)
          end

          context 'when field is define in context' do
            before { subject.context[:fields] = { description: {} } }
            # it 'should be triggered by calling the field name as a method' do
            #   expect(subject).to receive(:literal).with(:description, '123', {})
            #   subject.description "123"
            # end
            # it 'should accept multiple values' do
            #   expect(subject).to receive(:literal).exactly(3).times
            #   subject.description "123", "456", "789"
            # end

            it 'should return literal nodes in an array' do
              result = subject.description("123", "456", "789")
              expect(result).to include(AST::Literal)
            end
          end

          context 'when field is not defined' do
            it 'should raise method missing error when calling the field name as a method' do
              expect{ subject.not_defined() }.to raise_error(NoMethodError)
            end
          end
        end

        # describe 'prefix' do
        #   it 'should set the literal prefix option to true' do
        #     literals = (1..3).map { |i| AST::Literal.new(:int, i) }
        #     subject.prefix(literals)

        #     literals.each do |literal|
        #       expect(literal.options).to include(prefix: true)
        #     end

        #   end
        # end

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
