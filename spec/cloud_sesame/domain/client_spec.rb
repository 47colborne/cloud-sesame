module CloudSesame
	module Domain
		describe Client do

			class Searchable; end

			subject { Client.new(Searchable) }

			describe '.configure' do
				context 'when block is given' do
					it 'should yield back global config' do
						global_config = Client.global_config
						expect{ |b| Client.configure(&b) }.to yield_with_args(global_config)
					end
				end
			end

			describe '.global_config' do
				context 'when calling it first time' do
					before { Client.instance_variable_set(:@global_config, nil) }
					it 'should initialize an config object on first call' do
						expect(Config).to receive(:new)
						Client.global_config
					end
				end
				context 'when calling it' do
					before { Client.global_config }
					it 'should not re-initialize an config object' do
						expect(Config).to_not receive(:new)
						Client.global_config
					end
				end
				it 'should return an config object' do
					expect(Client.global_config).to be_kind_of(Config)
				end
			end

			describe '#config' do
				context 'when calling it first time' do
					it 'should initialize an config object from global config' do
						global_config = Client.global_config
						expect(Config).to receive(:new).with(global_config)
						subject.config
					end
				end
				context 'when calling it' do
					before { subject.config }
					it 'should no re-initialize an config object' do
						expect(Config).to_not receive(:new)
						subject.config
					end
				end
				it 'should return an config object' do
					expect(Client.global_config).to be_kind_of(Config)
				end
			end

			describe '#search' do
				let(:aws_client) { OpenStruct.new }
				let(:params) { {} }
				before { allow(subject).to receive(:aws_client).and_return(aws_client) }
				it 'should call fetch on executor' do
					expect(subject.send(:executor)).to receive(:fetch).with(params)
					subject.search params
				end
			end

		end
	end
end






