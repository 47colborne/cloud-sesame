module CloudSesame
	module Domain
		module ClientModule
			module Caching
				describe RailsCache do

					# FAKE RAILS AND RAILS CACHE
					# =====================================
					class ::Rails
						def self.cache
							@cache ||= FakeCache.new
						end
					end

					class ::FakeCache
						def table
							@table ||= {}
						end
						def fetch(key, &block)
							table[key] ||= (block.call if block_given?)
						end
					end

					# FAKE SEARCHABLE CLASS
					# =====================================
					class Searchable; end

					# HELPERS
					# =====================================
					def hashify(params)
						subject.send(:hashify, params)
					end

					# TESTS
					# =====================================

					let(:client) { OpenStruct.new(search: nil) }
					subject { RailsCache.new(Searchable) { client } }

					shared_examples 'cache stored' do
						it 'should cache the result' do
							expect{ subject.fetch(params) }.to change{ Rails.cache.table.keys.size }
							expect(Rails.cache.table[hashify(params)]).to eq results
						end
					end

					describe 'fetch' do
						let(:params) {{ query: "test" }}
						let(:results) { OpenStruct.new(status: {}, hits: [], facets: []) }

						before do
							Rails.cache.table.clear
							allow(subject).to receive(:search).and_return(results)
						end

						it 'should use the hash key generated from params to fetch the cache from Rails' do
							hash_key = hashify(params)
							expect(Rails.cache).to receive(:fetch).with(hash_key)
							subject.fetch(params)
						end

						context 'with non-cached search' do
							include_examples "cache stored"
							it 'should trigger search with params' do
								expect(subject).to receive(:search).with(params)
								subject.fetch(params)
							end
						end

						context 'with cached search' do
							include_examples "cache stored"
							it 'should not trigger search with params' do
								subject.fetch(params)
								expect(subject).to_not receive(:search)
								subject.fetch(params)
							end
						end

					end

				end
			end
		end
	end
end
