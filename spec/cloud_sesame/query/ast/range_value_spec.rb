module CloudSesame
	module Query
		module AST
			describe RangeValue do

				describe 'initialize' do
					shared_examples 'initialize with initial value' do
						it 'should be an array' do
							expect(subject.value).to be_kind_of(Array)
						end
						it 'should not be empty' do
							expect(subject.value).to_not be_empty
						end
						it 'should capture the range information' do
							expect(subject.value).to eq data
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
							"{, 100]" => ['{', '', '100', ']'],
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
							expect(subject.value).to eq ['{', nil, nil, '}']
						end
					end
				end

			end
		end
	end
end
