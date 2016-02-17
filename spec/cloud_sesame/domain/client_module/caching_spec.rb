module CloudSesame
	module Domain
		module ClientModule
			describe Caching do

				# SETUP
				# =======================================

				class Caching::GoodCache < Caching::Base
					def fetch(params); end
				end

				class Caching::BadCache < Caching::Base
				end

				class TestClient
					include Caching

					def aws_client
						nil
					end

					def searchable
						nil
					end
				end

				# TESTS
				# =======================================

				subject { TestClient.new }

				describe '#caching_with' do
					context 'when giving an existing caching module' do
						context 'and caching_module respond to fetch' do
							let(:caching_module) { Caching::GoodCache }
							before {
								subject.caching_with(:GoodCache) }
							it 'should set executor to the caching module' do
								expect(subject.send(:executor)).to be_kind_of caching_module
							end
						end
					end
					context 'when giving a non-existing caching module' do
						it 'should raise Unrecognized Caching Module' do
							expect{ subject.caching_with(:RedisCache) }.to raise_error(Error::Caching, "Unrecognized Caching Module")
						end
					end
				end

				describe 'executor getter' do
					it 'should return an Caching::NoCache executor by default' do
						expect(subject.executor).to be_kind_of(Caching::NoCache)
					end
					it 'should default to Caching::NoCache' do
						expect(Caching::NoCache).to receive(:new).with(subject.searchable) do |_, &lazy_client|
							expect(lazy_client.call).to eq subject.aws_client
						end
						subject.executor
					end
				end

				describe 'executor setter' do
					it 'should accept a caching module' do
						expect(Caching::GoodCache).to receive(:new).with(subject.searchable) do |_, &lazy_client|
							expect(lazy_client.call).to eq subject.aws_client
						end
						subject.executor = Caching::GoodCache
					end
					it 'should return a Caching::GoodCache instance' do
						subject.executor = Caching::GoodCache
						expect(subject.executor).to be_kind_of Caching::GoodCache
					end
				end

			end
		end
	end
end
