require 'spec_helper'

describe ThePirateBay::Torrent do
  let(:api) { ThePirateBay.new }

  describe '.search' do
    context 'without results' do
      before do
        stub_get('search/Rare').
          to_return(:status => 200, :body => fixture('torrent/search_no_results.html'))
        @torrents = api.torrents.search('Rare')
      end

      it 'returns empty array' do
        expect(@torrents.class).to eq(Array)
        expect(@torrents.count).to eq(0)
      end
    end

    context 'with results' do
      before do
        stub_get('search/Fringe').
          to_return(:status => 200, :body => fixture('torrent/search.html'))
        @torrents = api.torrents.search('Fringe')
      end

      it 'returns torrents results' do
        expect(@torrents.class).to eq(Array)
      end

      it 'instantiates torrents collection objects' do
        expect(@torrents.first.class).to eq(ThePirateBay::Torrent::Collection)
      end

      it 'parses torrents attributes correctly' do
        torrent = @torrents.first
        expect(torrent.id).to eq(7810640)
        expect(torrent.name).to eq('Fringe S05E06 Season 5 Episode 6 HDTV x264 [GlowGaze]')
        expect(torrent.type).to eq('Video > TV shows')
        expect(torrent.size).to eq('303.89 MB')
        expect(torrent.seeders).to eq(413)
        expect(torrent.leechers).to eq(117)
        expect(torrent.magnet_uri).to eq('magnet:?xt=urn:btih:0f4e3c1a4618b6d9658427e7778c602cd7c05ea0&dn=Fringe+S05E06+Season+5+Episode+6+HDTV+x264+%5BGlowGaze%5D&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80&tr=udp%3A%2F%2Ftracker.publicbt.com%3A80&tr=udp%3A%2F%2Ftracker.istole.it%3A6969&tr=udp%3A%2F%2Ftracker.ccc.de%3A80')
        expect(torrent.uploaded_at).to eq('Today 04:11')
        expect(torrent.uploaded_by).to eq('GlowGaze')
        expect(torrent.comments_count).to eq(2)
      end
    end
  end

  context '.find' do
    it 'returns a particular torrent' do
      stub_get('torrent/7723168').
        to_return(:status => 200, :body => fixture('torrent/find.html'))

      torrent = api.torrents.find('7723168')
      expect(torrent.id).to eq(7723168)
      expect(torrent.name).to eq('Fringe S05E03 HDTV x264-LOL [eztv]')
      expect(torrent.description).to eq("#EZTV @ EFNet -&gt; To avoid fakes, ALWAYS check that the torrent was added by eztv. \nhttp://eztv.it/\n\nEpisode: Fringe S05E03 HDTV x264-LOL\nScreenshots:")
      expect(torrent.seeders).to eq('2461')
      expect(torrent.leechers).to eq('118')
      expect(torrent.quality).to eq('+4 / -0 (+4)')
      expect(torrent.size).to eq('288.87 MiB (302897843 Bytes)')
      expect(torrent.type).to eq('Video > TV shows')
      expect(torrent.hash).to eq('84C153E4064D1AC1CC151A09070C8740C318D271')
      expect(torrent.uploaded_at).to eq('2012-10-13 12:33:16 GMT')
      expect(torrent.uploaded_by).to eq('eztv')
      expect(torrent.comments_count).to eq('6')
      expect(torrent.files_count).to eq('1')
      expect(torrent.spoken_language).to eq('English')
      expect(torrent.written_language).to eq('French')
      expect(torrent.tags).to eq('YIFY 720p 1080p movies x264 Bluray BrRip')
      expect(torrent.imdb_id).to eq('tt1985966')
    end
  end
end
