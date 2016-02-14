module CloudSesame
	module Domain
		module ClientModule
			module Caching
				describe Base do

					class Searchable; end

					subject { Base.new({}, Searchable) }

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
