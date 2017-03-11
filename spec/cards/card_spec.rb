require "spec_helper"

RSpec.describe Realms::Cards::Card do
  describe "defaults" do
    before do
      class SomeCard < described_class; end
    end
    let(:card) { SomeCard.new }

    include_examples "factions", []
    include_examples "cost", 0
  end

  describe "overriding defaults" do
    before do
      class SomeCard < described_class
        cost 1
        faction :blob
      end
    end
    let(:card) { SomeCard.new }

    include_examples "factions", :blob
    include_examples "cost", 1
  end
end
