require "spec_helper"

RSpec.describe Thrones::Game do
  it "is alive" do
    expect(described_class.structure).not_to be_nil
  end
end