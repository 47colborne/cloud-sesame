module CloudSesame
  module Query
    module DSL
      describe KGramPhraseMethods do

        class Product
          include CloudSesame
          define_cloudsearch do
            field :name, query: { weight: 2 }, type: :string
            field :description, query: { weight: 0.4 }, type: :string
          end
        end

        subject(:cloudsearch) { Product.cloudsearch.builder }
        let(:root) { cloudsearch.request.filter_query.root }

        describe '#k_gram_phrase' do
          let(:phrase) { 'listerine mouth wash' }

          it 'inserts an OR node at its scope level' do
            expect { cloudsearch.k_gram_phrase(:name, phrase) }.to change { root.children }.by([AST::Or])
          end

          describe 'in the OR node' do
            let(:or_node) { root.children.first }

            it 'builds a phrase node with original term' do
              cloudsearch.k_gram_phrase(:name, phrase)

              phrase_node = or_node.children.first
              expect(phrase_node).to be_kind_of AST::Phrase
              expect(phrase_node.child.value).to eq(phrase)
            end

            it 'builds a term node with original term' do
              cloudsearch.k_gram_phrase(:name, phrase)

              term_node = or_node.children.last
              expect(term_node).to be_kind_of AST::Term
              expect(term_node.child.value).to eq(phrase)
            end

            it 'builds bunch of phrase nodes with k grams' do
              cloudsearch.k_gram_phrase(:name, phrase)
              k_nodes = or_node.children[1..-1]

              expect(k_nodes[0]).to be_kind_of AST::And

              expect(k_nodes[1]).to be_kind_of AST::Phrase
              expect(k_nodes[1].options[:boost]).to eq(10)
              expect(k_nodes[1].child.value).to eq('listerine mouth')

              expect(k_nodes[2]).to be_kind_of AST::And

              expect(k_nodes[3]).to be_kind_of AST::Phrase
              expect(k_nodes[3].options[:boost]).to eq(10)
              expect(k_nodes[3].child.value).to eq('mouth wash')
            end

            it 'builds the correct first And node' do
              cloudsearch.k_gram_phrase(:name, phrase)
              and_node = or_node.children[1..-1][0]

              expect(and_node.options[:boost]).to eq(12)

              expect(and_node.children.first).to be_kind_of AST::Phrase
              expect(and_node.children.first.child.value).to eq('listerine mouth')

              expect(and_node.children.last).to be_kind_of AST::Term
              expect(and_node.children.last.child.value).to eq('wash')
            end

            it 'builds the correct second And node' do
              cloudsearch.k_gram_phrase(:name, phrase)
              and_node = or_node.children[1..-1][2]

              expect(and_node.options[:boost]).to eq(12)

              expect(and_node.children.first).to be_kind_of AST::Phrase
              expect(and_node.children.first.child.value).to eq('mouth wash')

              expect(and_node.children.last).to be_kind_of AST::Term
              expect(and_node.children.last.child.value).to eq('listerine')
            end
          end

          context 'when phrase is empty' do
            let(:phrase) { nil }

            it 'does not build anything' do
              expect { cloudsearch.k_gram_phrase(:name, phrase) }.to_not change { root.children }
            end
          end
        end

      end
    end
  end
end