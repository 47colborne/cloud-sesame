module CloudSesame
	module Domain
		module ClientModule
			module Caching
				describe Base do

					class Searchable; end

					let(:client) { instance_double(Client) }
					subject { Base.new(client, Searchable) }

					describe 'fetch' do
						it 'should raise an error by default' do
							expect{ subject.fetch({}) }.to raise_error(Error::Caching, "Caching Module needs #fetch method and accepts params")
						end
					end

				end
			end
		end
	end
end
