require "spec_helper"

module CloudSesame
  module Query
    module Node
      describe Page do
        let(:node) { Page.new(arguments) }

        describe '#initialize' do
          context 'when arguments passed in' do
            let(:arguments) { { size: 13 } }
            it 'should initialize the page with the page argument' do
              expect(node.page).to eq 1
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
              node = Page.new(size: arguments[:size])
              node.page = arguments[:page]
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

        describe '#compile' do
          context 'when cursor is not set' do
            let(:arguments) { { size: 13, page: 3 } }

            it 'compiles with start and size' do
              expect(node.compile).to include start: 26, size: 13
            end
          end
          context 'when cursor is set' do
            let(:arguments) { { cursor: 3, size: 13, page: 2 } }

            it 'compiles with only cursor and size' do
              expect(node.compile).to include cursor: 3, size: 13
              expect(node.compile).to_not include :start
            end
          end
        end
      end
    end
  end
end
