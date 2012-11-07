require "spec_helper"

describe ThePirateBay::Torrent do
  let(:api) { ThePirateBay.new }
    
  context ".search" do
    it "returns html torrents results" do
      api.torrents.search("Fringe").should include("Fringe")
    end
  end
  
  context ".find" do
    it "returns a particular torrent html" do
      api.torrents.find("7723168").should include("Fringe S05E03 HDTV")
    end
  end
end