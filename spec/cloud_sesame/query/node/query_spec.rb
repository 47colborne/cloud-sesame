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
            it 'should initalize an empty terms if query is empty' do
              expect(node.terms).to eq []
            end
            it 'should accept query as args and initialize terms' do
              arguments[:query] = "hello world"
              expect(node.terms).to eq ["hello", "world"]
            end
          end
          context 'when arguments not passed in' do
            it 'should initialize an empty terms' do
              expect(node.terms).to eq []
            end
          end
        end

        describe '#query' do
          it 'should return a string with all the terms added' do
            node.terms = ["term1", " term2", "term3 ", "-term4"]
            expect(node.query).to eq "term1 term2 term3 -term4"
          end
        end

        describe '#run' do
          it 'should return a serialized hash contains query string' do
            node.terms = ["term1", " term2", "term3 ", "-term4"]
            expect(node.compile).to eq({ query: "term1 term2 term3 -term4" })
          end
        end

      end
    end
  end
end

