require 'spec_helper'

module CloudSesame
	module Query
		module DSL
			describe BlockMethods do

				# Setup Test Class
				class Product
					include CloudSesame
					define_cloudsearch {}
				end

				subject(:cloudsearch) { Product.cloudsearch.builder }

				# AND
				# =======================================================
				describe '#and' do

					it 'should create an AND node' do
						expect(AST::And).to receive(:new).once
						subject.and
					end

					context 'when given a block' do

						context 'when called from cloudsearch' do
							it 'should become a child of root node' do
								node = nil
								subject.and { node = self; }
								expect(subject.request.filter_query.root.children).to include(node)
							end
							it 'should return cloudsearch' do
								expect(subject.and {}).to eq subject
							end
							it 'should use self as the dsl scope in the block' do
								block = ->(scope, node) { expect(scope).to eq node }
								subject.and { block.call(dsl_scope, self) }
							end
						end

						context 'when called from inside a block' do
							it 'should become a child of the dsl_scope' do
								parent = nil
								child = nil
								subject.or { parent = self; child = and! {} }
								expect(parent.children).to include(child)
							end
							it 'should return the node it self' do
								node = AST::And.new({})
								return_node = nil
								allow(AST::And).to receive(:new).and_return(node)
								subject.or { return_node = and! {} }
								expect(return_node).to eq node
							end
						end

					end

					context 'when not given a block' do
						it 'should reutnr a block chaining relation object' do
							expect(subject.and).to be_kind_of(AST::BlockChainingRelation)
						end
						it 'should not add a child to it\'s dsl scope' do
							expect{ subject.and }.to_not change { subject.request.filter_query.root.children.size }
						end
					end

				end

				# OR
				# =======================================================
				describe '#or' do

					it 'should create an Or node' do
						expect(AST::Or).to receive(:new).once
						subject.or
					end

					context 'when called from cloudsearch' do
						it 'should become a child of root node' do
							node = nil
							subject.or { node = self; }
							expect(subject.request.filter_query.root.children).to include(node)
						end
						it 'should return cloudsearch' do
							expect(subject.or {}).to eq subject
						end
						it 'should use self as the dsl scope in the block' do
							block = ->(scope, node) { expect(scope).to eq node }
							subject.and { block.call(dsl_scope, self) }
						end
					end

					context 'when called from inside a block' do
						it 'should become a child of the dsl_scope' do
							parent = nil
							child = nil
							subject.and { parent = self; child = or! {} }
							expect(parent.children).to include(child)
						end
						it 'should return the node it self' do
							node = AST::Or.new({})
							return_node = nil
							allow(AST::Or).to receive(:new).and_return(node)
							subject.and { return_node = or! {} }
							expect(return_node).to eq node
						end
					end
				end

			end
		end
	end
end
