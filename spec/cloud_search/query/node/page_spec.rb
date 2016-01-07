require "spec_helper"

module CloudSearch
  module Query
    module Node
      describe Page do
        let(:node) { Page.new(arguments) }

        describe '#initialize' do
          context 'when arguments passed in' do
            let(:arguments) { { page: 2, size: 13 } }
            it 'should initialize the page with the page argument' do
              expect(node.page).to eq 2
            end
            it 'should initialize the size with the size argument' do
              expect(node.size).to eq 13
            end
          end
          context 'when arguments NOT passed in' do
            let(:arguments) { {} }
            it 'should default the page to 1' do
              expect(node.page).to eq 1
            end
            it 'should default the size to 10' do
              expect(node.size).to eq 10
            end
          end
        end

        describe 'start' do
          [{
            page: 1, size: 100, expect_start: 0
          }, {
            page: 2, size: 10, expect_start: 10
          }, {
            page: 3, size: 13, expect_start: 26
          }].each do |arguments|
            it 'should calculate and return the starting point' do
              node = Page.new arguments
              expect(node.start).to eq arguments[:expect_start]
            end
          end
        end

        describe '#run' do
          let(:arguments) { { page: 3, size: 13 } }
          it 'should return the calculated start' do
            expect(node.compile).to include start: node.start
          end
          it 'should return the size' do
            expect(node.compile).to include size: arguments[:size]
          end
        end

      end
    end
  end
end
