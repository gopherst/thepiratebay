require "spec_helper"

describe ThePirateBay::Torrent do
  let(:api) { ThePirateBay.new }

  context ".search" do
    before do
      stub_get("search/Fringe").
        to_return(:status => 200, :body => fixture("torrent/search.html"))
      @torrents = api.torrents.search("Fringe")
    end

    it "returns torrents results" do
      @torrents.class.should == Array
    end

    it "instantiates torrents collection objects" do
      @torrents.first.class.should == ThePirateBay::Torrent::Collection
    end

    it "assigns torrents attributes" do
      @torrents.first.id.should == "7810640"
    end
  end

  context ".find" do
    it "returns a particular torrent" do
      stub_get("torrent/7723168").
        to_return(:status => 200, :body => fixture("torrent/find.html"))
      torrent = api.torrents.find("7723168")
      torrent.name.should == "Fringe S05E03 HDTV x264-LOL [eztv]"
    end
  end
end
