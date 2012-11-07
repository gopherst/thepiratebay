require "spec_helper"

describe ThePirateBay do
  
  it "should respond to 'new' message" do
    subject.should respond_to :new
  end

  it "should receive 'new' and initialize ThePirateBay::Client instance" do
    subject.new.should be_a ThePirateBay::Client
  end
  
end