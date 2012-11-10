require "the_pirate_bay/torrent"
require "the_pirate_bay/torrent/collection"

module ThePirateBay
  class Client < API
        
    def torrents
      Torrent
    end
    
  end # Client
end # ThePirateBay