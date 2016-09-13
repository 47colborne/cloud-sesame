module CloudSesame
  module Query
    module DSL
      describe AnyTermMethods do
        class Product
          include CloudSesame
          define_cloudsearch do
            field :name, query: { weight: 2 }, type: :string
            field :description, query: { weight: 0.4 }, type: :string
          end
        end

        subject(:cloudsearch) { Product.cloudsearch.builder }
        let(:root) { cloudsearch.request.filter_query.root }

        describe '#any_term' do
          let(:phrase) { 'listerine mouth wash' }

          it 'inserts an OR node at its scope level' do
            expect { cloudsearch.any_term(:name, phrase) }.to change { root.children }.by([AST::Or])
          end

          describe 'in the OR node' do
            let(:or_node) { root.children.first }

            it 'builds a term node with each word' do
              cloudsearch.any_term(:name, phrase)

              expect(or_node.children[0]).to be_kind_of AST::Term
              expect(or_node.children[0].child.value).to eq('listerine')
            end

            context 'when - is in phrase' do
              let(:phrase) { 'a-b c' }

              it 'only splits on space' do
                cloudsearch.any_term(:name, phrase)

                expect(or_node.children.length).to eq(2)
              end
            end
          end

          context 'when phrase is empty' do
            let(:phrase) { nil }

            it 'does not build anything' do
              expect { cloudsearch.any_term(:name, phrase) }.to_not change { root.children }
            end
          end
        end
      end
    end
  end
end
