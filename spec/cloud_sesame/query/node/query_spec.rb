require "spec_helper"

module CloudSesame
  module Query
    module Node
      describe Query do
        let(:arguments) {{ }}
        let(:node) { Query.new(arguments) }

        describe '#initialize' do
          context 'when arguments passed in' do
            let(:arguments) {{ query: "" }}
            it 'should initalize an empty string if query is empty' do
              expect(node.query).to eq ""
            end
            it 'should accept query as args and initialize query' do
              arguments[:query] = "hello world"
              expect(node.query).to eq "hello world"
            end
          end
          context 'when arguments not passed in' do
            it 'should initialize an empty terms' do
              expect(node.query).to eq nil
            end
          end
        end

        describe '#query' do
          it 'should return the query string' do
            node.query = ["term1", "term2", "term3", "-term4"].join(' ')
            expect(node.query).to eq "term1 term2 term3 -term4"
          end
        end

        describe '#compile' do
          it 'should parse with fuzziness if fuzziness is defined' do
            fuzziness = Fuzziness.new
            node = Query.new(fuzziness: fuzziness)
            node.query = ["term1", "term2", "term3", "-term4"].join(' ')
            expect(fuzziness).to receive(:parse).with(node.query)
            node.compile
          end
          it 'should return a serialized hash contains query string' do
            node.query = ["term1", "term2", "term3", "-term4"].join(' ')
            expect(node.compile).to eq({ query: "term1 term2 term3 -term4" })
          end
        end

      end
    end
  end
end

