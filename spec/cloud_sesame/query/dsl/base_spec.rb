module CloudSesame
  module Query
    module DSL
      describe Base do

        class TestClass
          include Base
        end

        subject { TestClass.new }

        shared_examples 'return self instance' do
          it 'should return itself' do
            expect(result).to eq subject
          end
        end

        describe '#method_return' do
          let(:result) { subject.send(:dsl_return) }
          include_examples 'return self instance'
        end

        describe '#method_scope' do
          let(:result) { subject.send(:dsl_scope) }
          include_examples 'return self instance'
        end

      end
    end
  end
end
