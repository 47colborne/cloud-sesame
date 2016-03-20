module CloudSesame
  module Query
    module AST
      describe DateValue do

        subject { DateValue.parse(value) }

        describe '.parse' do
          context 'when value is a date or datetime object' do
            let(:value) { DateTime.now }
            it 'should return an DateValue object' do
              expect(subject).to be_kind_of(DateValue)
              expect(subject.value).to be_kind_of(Date)
            end
          end
          context 'when value is a datetime in string format' do
            let(:value) { "2016-03-09T13:50:41+00:00" }
            it 'should return an DateValue object' do
              expect(subject).to be_kind_of(DateValue)
              expect(subject.value).to be_kind_of(Date)
            end
          end
          context 'when value is a date in string format' do
            let(:value) { "2016-03-09" }
            it 'should return an DateValue object' do
              expect(subject).to be_kind_of(DateValue)
              expect(subject.value).to be_kind_of(Date)
            end
          end
          context 'when value is a RangeValue object' do
            let(:value) { RangeValue.new.gt(Date.today).lt(Date.today + 3) }
            it 'should return an RangeValue object contains DateValue inside' do
              expect(subject).to be_kind_of(RangeValue)
              expect(subject.value[1, 2]).to include(DateValue)
            end
          end
          context 'when value is a range object' do
            let(:value) { "[2016-03-09T13:50:41+00:00,2016-03-10]" }
            it 'should return an RangeValue object contains DateValue inside' do
              expect(subject).to be_kind_of(RangeValue)
              expect(subject.value[1, 2]).to include(DateValue)
            end
          end
        end

      end
    end
  end
end
