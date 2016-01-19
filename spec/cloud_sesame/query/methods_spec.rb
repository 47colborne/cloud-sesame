require 'spec_helper'

module CloudSesame
  module Query
    describe Methods do
      let(:client) { {} }
      let(:searchable_class) { "Test" }
      subject { Builder.new(client, searchable_class) }

    end
  end
end
