require "spec_helper"

RSpec.describe GmoCoin do
  it "has a version number" do
    expect(GmoCoin::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end
end
