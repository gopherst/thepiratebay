require 'the_pirate_bay/torrent'
require 'the_pirate_bay/torrent/collection'

module ThePirateBay
  class Client

    def torrents
      Torrent
    end

  end # Client
end # ThePirateBay
