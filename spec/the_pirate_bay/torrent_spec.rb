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

    it "parses torrents attributes correctly" do
      torrent = @torrents.first
      torrent.id.should == "7810640"
      torrent.name.should == "Fringe S05E06 Season 5 Episode 6 HDTV x264 [GlowGaze]"
      torrent.type.should == "Video > TV shows"
      torrent.size == "303.89 MB"
      torrent.seeders == "413"
      torrent.leechers == "117"
      torrent.magnet_uri == "magnet:?xt=urn:btih:0f4e3c1a4618b6d9658427e7778c602cd7c05ea0&dn=Fringe+S05E06+Season+5+Episode+6+HDTV+x264+%5BGlowGaze%5D&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80&tr=udp%3A%2F%2Ftracker.publicbt.com%3A80&tr=udp%3A%2F%2Ftracker.istole.it%3A6969&tr=udp%3A%2F%2Ftracker.ccc.de%3A8"
      torrent.uploaded_at == "Today 04:11"
      torrent.uploaded_by == "GlowGaze"
      torrent.comments_count == "2"
    end
  end

  context ".find" do
    it "returns a particular torrent" do
      stub_get("torrent/7723168").
        to_return(:status => 200, :body => fixture("torrent/find.html"))

      torrent = api.torrents.find("7723168")
      torrent.id.should == "7723168"
      torrent.name.should == "Fringe S05E03 HDTV x264-LOL [eztv]"
      torrent.description.should == "#EZTV @ EFNet -&gt; To avoid fakes, ALWAYS check that the torrent was added by eztv. \nhttp://eztv.it/\n\nEpisode: Fringe S05E03 HDTV x264-LOL\nScreenshots:"
      torrent.seeders.should == "2461"
      torrent.leechers.should == "118"
      torrent.quality.should == "+4 / -0 (+4)"
      torrent.size.should == "288.87 MiB (302897843 Bytes)"
      torrent.type.should == "Video > TV shows"
      torrent.hash.should == "84C153E4064D1AC1CC151A09070C8740C318D271"
      torrent.uploaded_at.should == "2012-10-13 12:33:16 GMT"
      torrent.uploaded_by.should == "eztv"
      torrent.comments_count.should == "6"
      torrent.files_count.should == "1"
      torrent.spoken_language.should == "English"
      torrent.written_language.should == "French"
      torrent.tags.should == "YIFY 720p 1080p movies x264 Bluray BrRip"
      torrent.imdb_id.should == "tt1985966"
    end
  end
end
