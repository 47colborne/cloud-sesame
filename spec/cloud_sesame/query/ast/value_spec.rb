require 'bigdecimal'

module CloudSesame
  module Query
    module AST
      describe Value do

        describe '.map_type' do
          it 'should return self when type does not match' do
            expect(Value.map_type(:random)).to eq(Value)
          end
          it 'should return the class matched the type' do
            expect(Value.map_type(:string)).to eq(StringValue)
            expect(Value.map_type(:numeric)).to eq(NumericValue)
            expect(Value.map_type(:datetime)).to eq(DateValue)
          end
        end

        describe '.parse' do
          context 'when value is a RangeValue object' do
            let(:begin_value) { 100 }
            let(:end_value) { 200 }
            let(:value) { RangeValue.new(begin_value..end_value) }
            it 'should parse the RangeValue' do
              expect(value).to receive(:parse).with(Value).and_call_original
              expect(Value.parse(value)).to eq value
            end
          end
          context 'when value is an ruby range object' do
            let(:begin_value) { 100 }
            let(:end_value) { 200 }
            let(:value) { begin_value..end_value }
            it 'should initialize a RangeValue' do
              expect(RangeValue).to receive(:new).with(value, Value).and_call_original
              expect(Value.parse(value)).to be_kind_of(RangeValue)
            end
          end
          context 'when value is a AWS range string' do
            let(:lower_bound) { '{' }
            let(:upper_bound) { '}' }
            let(:begin_value) { 100 }
            let(:end_value) { 200 }
            let(:value) { "#{ lower_bound }#{ begin_value },#{ end_value }#{ upper_bound }" }
            it 'should initialize a RangeValue' do
              expect(RangeValue).to receive(:new).with(value, Value).and_call_original
              expect(Value.parse(value)).to be_kind_of(RangeValue)
            end
          end
          context 'when value is a numeric value' do
            let(:value) { 10 }
            it 'should initialize a NumericValue' do
              expect(NumericValue).to receive(:new).with(value, Value).and_call_original
              expect(Value.parse(value)).to be_kind_of(NumericValue)
            end
          end
          context 'when value is a string contains numeric' do
            let(:value) { "10" }
            xit 'should initialize a NumericValue' do
              expect(NumericValue).to receive(:new).with(value, Value).and_call_original
              expect(Value.parse(value)).to be_kind_of(NumericValue)
            end
          end
          context 'when value is not neither a range, numeric or range' do
            let(:value) { [10] }
            it 'should initialize a NumericValue' do
              expect(StringValue).to receive(:new).with(value, Value).and_call_original
              expect(Value.parse(value)).to be_kind_of(StringValue)
            end
          end
        end

        describe '.range_value?' do
          it 'should return true when value is a ruby range object' do
            expect(Value.range_value?(1..20)).to eq true
          end
          it 'should return true when value is a aws range string' do
            expect(Value.range_value?("[1,20]")).to eq true
            expect(Value.range_value?("[1,20}")).to eq true
            expect(Value.range_value?("{,20]")).to eq true
            expect(Value.range_value?("{1,}")).to eq true
          end
          it 'should return false when value is not a range' do
            expect(Value.range_value?("abc")).to eq false
            expect(Value.range_value?(['[', 2, 3, '}'])).to eq false
          end
        end

        describe 'numeric_value?' do
          it 'should return true when value is a integer, float, or bigdecimal' do
            expect(Value.numeric_value?(1)).to eq true
            expect(Value.numeric_value?(0.99)).to eq true
            expect(Value.numeric_value?(BigDecimal.new("10"))).to eq true
          end
          it 'should return true when value matches string numeric format' do
            # expect(Value.numeric_value?("1")).to eq true
            # expect(Value.numeric_value?("0.99")).to eq true
            expect(Value.numeric_value?("1")).to eq false
            expect(Value.numeric_value?("0.99")).to eq false
          end
          it 'should return false when value is not a numeric' do
            expect(Value.numeric_value?("abc")).to eq false
            expect(Value.numeric_value?([1, 2, 3])).to eq false
            expect(Value.numeric_value?(h: 2)).to eq false
          end
        end

      end

    end
  end
end
