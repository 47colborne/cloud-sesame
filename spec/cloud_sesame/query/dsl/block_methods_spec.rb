module CloudSesame
	module Query
		module DSL
			describe BlockStyledOperators do

				# Setup
				# =================================================

				class Product
					include CloudSesame
					define_cloudsearch {}
				end

				subject(:cloudsearch) { Product.cloudsearch.builder }

				# Block Style Clause
				# =================================================
				shared_examples 'block styled clause' do

					let(:node) { klass1.new({}) }
					let(:root) { subject.request.filter_query.root }

					let(:empty_block) { Proc.new { } }
					let(:nested_block) { Proc.new { send(method, empty_block) } }

					let(:clause_call) { subject.send(clause1, &empty_block) }

					it "should create an multi-expression node" do
						expect(klass1).to receive(:new).once
						subject.send(clause1)
					end

					context 'when given a block' do
						before { allow(klass1).to receive(:new).and_return(node) }

						context 'when called from cloudsearch build' do
							it 'should add to root\'s children' do
								expect{ clause_call }.to change{ root.children.size }.by(1)
								expect(root.children).to include(node)
							end
							it 'should return the build itself' do
								expect(clause_call).to eq(subject)
							end
						end
						context 'when called within a nested block' do
							it 'should add to scope\'s children' do
								subject.send(clause2) do
									child = send(clause1, &empty_block)
									expect(_scope.children).to include(child)
								end
							end
							it 'should return the node it self' do
								subject.send(clause2) {
									child = send(clause1, &empty_block)
									expect(child).to eq(node)
								}
							end
						end
					end

					context 'when not given a block' do
						it 'should return a chaining block domain object' do
							expect(subject.send(clause1)).to be_kind_of(Domain::ChainingBlock)
						end
						it 'should NOT add any children to the scope node' do
							expect{ subject.send(clause1) }.to_not change{ root.children.size }
						end
					end
				end


				# AND
				# =======================================================
				describe '#and' do
					it_behaves_like 'block styled clause' do
						let(:klass1) { AST::And }
						let(:klass2) { AST::Or }
						let(:clause1) { :and! }
						let(:clause2) { :or! }
					end
				end

				# OR
				# =======================================================
				describe '#or' do
					it_behaves_like 'block styled clause' do
						let(:klass1) { AST::Or }
						let(:klass2) { AST::And }
						let(:clause1) { :or! }
						let(:clause2) { :and! }
					end
				end

			end
		end
	end
end
