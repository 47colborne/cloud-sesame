require "spec_helper"

module CloudSesame
  module Query
    module Node
      describe Query do
        let(:context) {{ }}
        subject { Query.new(context) }

        describe '#compile' do

          shared_examples 'common query compile actions' do
            before { subject.query = query_string }
            context 'and query is nil' do
              let(:query_string) { nil }
              it 'should return nil' do
                expect(subject.compile).to eq nil
              end
            end
            context 'and query is empty' do
              let(:query_string) { "" }
              it 'should return nil' do
                expect(subject.compile).to eq nil
              end
            end
            context 'and query contains one word' do
              let(:query_string) { "oneword" }
              it 'should include the original string inside parenthesis' do
                expect(subject.compile).to include("(#{ query_string })")
              end
            end
            context 'and query contains multiple words' do
              let(:query_string) { "one three fourty longword" }
              it 'should include the original string inside parenthesis' do
                expect(subject.compile).to include("(#{ query_string })")
              end
            end
          end

          shared_examples 'with additional parser defined' do |parser_name|
            before { subject.query = query_string }

            context 'and query string is nil' do
              let(:query_string) { nil }
              it "should not trigger #{ parser_name }" do
                expect(parser).to_not receive(:compile)
                subject.compile
              end
            end
            context 'and query string is empty' do
              let(:query_string) { "" }
              it "should not trigger #{ parser_name }" do
                expect(parser).to_not receive(:compile)
                subject.compile
              end
            end
            context 'and query string exist and not empty' do
              let(:query_string) { "not empty" }
              it "should trigger #{ parser_name }" do
                result = parser.compile(query_string)
                expect(parser).to receive(:compile).with(query_string).and_call_original
                expect(subject.compile).to include(result)
              end
            end
          end

          context 'when both fuzziness and sloppiness are not defined' do
            let(:context) {{ }}

            include_examples 'common query compile actions'
          end
          context 'when fuzziness is defined' do
            let(:query_string) { 'firstword secondword' }
            let(:parser) { Fuzziness.new }
            let(:context) {{ fuzziness: parser }}

            include_examples 'common query compile actions'
            include_examples 'with additional parser defined', "fuzziness"

            it 'applies fuzziness to each word in the query' do
              expect(subject.compile).to include('(firstword~2+secondword~2)')
            end

            context 'negative query terms' do
              let(:query_string) { 'firstword -excludedword' }

              it 'do not have fuzziness applied' do
                expect(subject.compile).to include('(firstword~2+-excludedword)')
              end
            end

            context 'wildcard query terms' do
              let(:query_string) { 'firstword wildcard*' }

              it 'do not have fuzziness applied' do
                expect(subject.compile).to include('(firstword~2+wildcard*)')
              end
            end
          end
          context 'when sloppiness is defined' do
            let(:parser) { Sloppiness.new(3) }
            let(:context) {{ sloppiness: parser }}
            include_examples 'common query compile actions'
            include_examples 'with additional parser defined', "sloppiness"
          end
        end

      end
    end
  end
end

