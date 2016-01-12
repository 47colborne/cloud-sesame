require 'spec_helper'

module CloudSearch
  module Query
    describe Builder do
      let(:client) { {} }
      let(:searchable_class) { "Test" }
      subject { Builder.new(client, searchable_class) }

    end
  end
end
