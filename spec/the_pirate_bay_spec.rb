require "spec_helper"

describe ThePirateBay do

  it "should respond to 'new' message" do
    expect(subject).to respond_to(:new)
  end

  it "should receive 'new' and initialize ThePirateBay::Client instance" do
    expect(subject.new).to be_a(ThePirateBay::Client)
  end

end
