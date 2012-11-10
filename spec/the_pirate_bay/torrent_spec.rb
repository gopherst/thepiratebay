require "spec_helper"

describe ThePirateBay::Torrent do
  let(:api) { ThePirateBay.new }
    
  context ".search", focus: true do
    let(:torrents) { api.torrents.search("Fringe") }
    
    it "returns torrents results" do
      torrents.class.should == Array
    end
    
    it "instantiates torrents collection objects" do
      torrents.first.class.should == ThePirateBay::Torrent::Collection
    end
    
    it "assigns torrents attributes" do
      torrents.first.id.should == "7811310"
    end
  end
  
  context ".find" do
    it "returns a particular torrent" do
      api.torrents.find("7723168").should include("Fringe S05E03 HDTV")
    end
  end
end