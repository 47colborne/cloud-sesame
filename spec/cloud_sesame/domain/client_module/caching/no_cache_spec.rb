module CloudSesame
	module Domain
		module ClientModule
			module Caching
				describe NoCache do

					class Searchable; end

					let(:client) { instance_double(Client) }
					subject { NoCache.new(client, Searchable) }

					describe 'fetch' do
						let(:params) {{}}
						it 'should search with params using client' do
							expect(client).to receive(:search).with(params)
							subject.fetch(params)
						end
					end

				end
			end
		end
	end
end
