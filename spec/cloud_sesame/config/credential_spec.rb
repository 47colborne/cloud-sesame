module CloudSesame
	module Config
		describe Credential do

			describe '#initialize' do
				it 'should accept access_key_id' do
					credential = Credential.new(access_key_id: 123)
					expect(credential.to_hash[:access_key_id]).to eq 123
				end
				it 'should accept access_key as an alias for access_key_id' do
					credential = Credential.new(access_key: 123)
					expect(credential.to_hash[:access_key_id]).to eq 123
				end
				it 'should accept secret_access_key' do
					credential = Credential.new(secret_access_key: 'secret')
					expect(credential.to_hash[:secret_access_key]).to eq 'secret'
				end
				it 'should accept secret_key as an alias for secret_access_key' do
					credential = Credential.new(secret_key: 'secret')
					expect(credential.to_hash[:secret_access_key]).to eq 'secret'
				end
			end

			describe 'access_key_id' do
				context 'getter' do
					subject { Credential.new(access_key: 123) }
					it 'should be defined' do
						expect(subject).to respond_to(:access_key_id)
						expect(subject.access_key_id).to eq 123
					end
					it 'should have an alias getter defined' do
						expect(subject).to respond_to(:access_key)
						expect(subject.access_key).to eq 123
					end
				end
				context 'writer' do
					let(:attributes) { subject.instance_variable_get(:@attributes) }
					it 'should be defined' do
						expect(subject).to respond_to(:access_key_id=)
						expect{ subject.access_key_id = 123 }.to change{ attributes[:access_key_id] }.from(nil).to(123)
					end
					it 'should have an alias writer defined' do
						expect(subject).to respond_to(:access_key=)
						expect{ subject.access_key = 123 }.to change{ attributes[:access_key_id] }.from(nil).to(123)
					end
				end
			end

			describe 'secret_access_key' do
				context 'getter' do
					subject { Credential.new(secret_key: 123) }
					it 'should be defined' do
						expect(subject).to respond_to(:secret_access_key)
						expect(subject.secret_access_key).to eq 123
					end
					it 'should have an alias getter defined' do
						expect(subject).to respond_to(:secret_key)
						expect(subject.secret_key).to eq 123
					end
				end
				context 'writer' do
					let(:attributes) { subject.instance_variable_get(:@attributes) }
					it 'should be defined' do
						expect(subject).to respond_to(:secret_access_key=)
						expect{ subject.secret_access_key = 123 }.to change{ attributes[:secret_access_key] }.from(nil).to(123)
					end
					it 'should have an alias writer defined' do
						expect(subject).to respond_to(:secret_key=)
						expect{ subject.secret_key = 123 }.to change{ attributes[:secret_access_key] }.from(nil).to(123)
					end
				end
			end

		end
	end
end
