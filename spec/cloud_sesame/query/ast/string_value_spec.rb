module CloudSesame
  module Query
    module AST
      describe StringValue do

        describe '.parse' do
          let(:value) { 'value' }

          it 'should instantiate a StringValue' do
            expect(StringValue).to receive(:new).with(value)
            StringValue.parse(value)
          end

          it 'should return the StringValue' do
            expect(StringValue.parse(value)).to be_kind_of(StringValue)
          end
        end

        describe '.compile' do
          subject { StringValue.new(value) }

          context 'when value is not present' do
            let(:value) { nil }

            it 'should return nothing' do
              expect(subject.compile).to eq nil
            end
          end

          context 'when value is present' do
            let(:value) { 'value' }

            it 'should return the escaped value' do
              expect(subject.compile).to eq "'#{ value }'"
            end
          end

          context 'when value contains a single quote character' do
            let(:value) { "value'" }

            it 'should return the escaped value' do
              expect(subject.compile).to eq "'value\\''"
            end
          end

          context 'when value contains a backslash character' do
            let(:value) { 'value\\' }

            it 'should return the escaped value' do
              expect(subject.compile).to eq "'value\\\\'"
            end
          end
        end

      end

    end
  end
end
