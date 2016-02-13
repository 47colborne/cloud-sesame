module CloudSesame
	module Query
		module AST
			describe RangeValue do

				describe 'initialize' do
					shared_examples 'initialize with initial value' do
						it 'should be an array' do
							expect(subject.data).to be_kind_of(Array)
						end
						it 'should not be empty' do
							expect(subject.data).to_not be_empty
						end
						it 'should capture the range information' do
							expect(subject.data).to eq data
						end
						context 'when begin and end value exists' do
							it 'should convert begin and end value to Value' do
								expect(subject.data[1]).to be_kind_of(Value) if data[1]
								expect(subject.data[2]).to be_kind_of(Value) if data[2]
							end
						end
					end

					context 'when given a range value' do
						{
							(0..10) => ['[', 0, 10, ']'],
							(0...10) => ['[', 0, 10, '}'],
							(Date.today..(Date.today + 3)) => ['[', Date.today, Date.today + 3, ']']
						}.each do |before_value, after_value|
							subject { RangeValue.new(before_value) }
							let(:data) { after_value }
							include_examples 'initialize with initial value'
						end
					end

					context 'when given a range value in string format' do
						{
							"[0, nil}" => ['[', 0, nil, '}'],
							"{, 100]" => ['{', nil, 100, ']'],
						}.each do |before_value, after_value|
							subject { RangeValue.new(before_value) }
							let(:data) { after_value }
							include_examples 'initialize with initial value'
						end
					end

					context 'when value is not given' do
						subject { RangeValue.new }
						let(:data) { [] }
						it 'should set the data to the default value' do
							expect(subject.data).to eq ['{', nil, nil, '}']
						end
					end
				end

			end
		end
	end
end
