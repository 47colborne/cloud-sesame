module CloudSesame
  module Query
    module AST
      describe NumericValue do

        describe 'compile' do
          let(:value) { 20 }
          subject { NumericValue.new(value) }
          it 'should return the data in string format' do
            expect(subject.compile).to eq "#{ value }"
          end
        end

        describe '==' do

          context 'when value comparing with is a integer' do
            subject { NumericValue.new(20) }

            it 'should return true if data equals to the value' do
              expect(subject == 20).to eq true
            end

            it 'should return false when data does not equal to the value' do
              expect(subject == 21).to eq false
            end

          end

          context 'when value comparing with is a float' do
            subject { NumericValue.new(0.99) }

            it 'should return true if data equals to the value' do
              expect(subject == 0.990).to eq true
            end

            it 'should return false when data does not equal to the value' do
              expect(subject == 1.0).to eq false
            end

          end

          context 'when value comparing with is a string' do
            subject { NumericValue.new("0.99") }

            it 'should return true if data equals to the value' do
              expect(subject == 0.990).to eq true
              expect(subject == "0.990").to eq true
            end

            it 'should return false when data does not equal to the value' do
              expect(subject == 1.0).to eq false
              expect(subject == "1.0").to eq false
            end
          end

        end

      end
    end
  end
end
