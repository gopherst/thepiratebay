require "the_pirate_bay/torrent"

module ThePirateBay
  class Client < API
        
    def torrents
      Torrent
    end
    
  end # Client
end # ThePirateBay