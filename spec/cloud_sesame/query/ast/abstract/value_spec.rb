module CloudSesame
	module Query
		module AST
			module Abstract
				describe Value do

					subject { Value.new(raw_value) }

					describe 'initialize' do
						context 'given the value is not nil' do
							let(:raw_value) { 1 }
							it 'should accept and store a value' do
								expect(subject.value).to eq raw_value
							end
							it 'should default changed to true' do
								expect(subject.changed).to be_truthy
							end
						end
						context 'given the value is nil' do
							let(:raw_value) { nil }
							it 'should accept and store a value' do
								expect(subject.value).to eq raw_value
							end
							it 'should default changed to false' do
								expect(subject.changed).to be_falsey
							end
						end
					end

					describe '#value setter' do
						context 'given a different value' do
							let(:raw_value) { 2 }
							let(:new_value) { 1 }
							before { subject.compile }
							it 'should set changed to true' do
								expect{ subject.value = new_value }.to change{ subject.changed }.from(be_falsey).to(be_truthy)
							end
							it 'should set the value' do
								expect{ subject.value = new_value }.to change{ subject.value }.from(raw_value).to(new_value)
							end
						end
						context 'given the same value' do
							let(:raw_value) { 2 }
							let(:new_value) { 2 }
							before { subject.compile }
							it 'should not set changed to true' do
								expect{ subject.value = new_value }.to_not change{ subject.changed }.from(be_falsey)
							end
						end
					end

					describe '#compile' do
						let(:raw_value) { 2 }
						context 'the value is changed' do
							it 'should compile the value' do
								expect(subject).to receive(:recompile).with(raw_value)
								subject.compile
							end
							it 'should update the compiled value' do
								expect{ subject.compile }.to change{ subject.compiled }.to(raw_value)
							end
							it 'should toggle the changed status to false' do
								expect{ subject.compile }.to change{ subject.changed }.from(true).to(false)
							end
						end
						context 'the value is the same' do
							before { subject.compile }
							it 'should not recompile' do
								expect(subject).to_not receive(:recompile)
								subject.compile
							end
							it 'should not change the compiled value' do
								expect{ subject.compile }.to_not change{ subject.compiled }
							end
						end
					end

					describe '#to_s' do
						let(:raw_value) { 2 }
						it 'should return the value in string format' do
							expect(subject.to_s).to eq raw_value.to_s
						end
					end

					describe '#==' do
						context 'given a Value object' do
							let(:raw_value) { 1 }
							let(:value) { Value.new(raw_value) }
							it 'should compare values based on their compiled value' do
								expect(value).to receive(:compile).and_call_original
								subject == value
							end
							it 'should return true if compiled values are the same' do
								expect(subject == value).to be_truthy
							end
						end
						context 'given a raw value' do
							let(:raw_value) { double(:string) }
							let(:value) { 1 }
							it 'should compare the value with the raw value' do
								expect(subject.value).to receive(:==).and_return(true)
								subject == value
							end
							it 'should compare the value with the compiled value if raw value is different' do
								response = double(:compiled_value)
								expect(subject).to receive(:compile).and_return(response)
								expect(response).to receive(:==)
								subject == value
							end
						end
					end


				end
			end
		end
	end
end
