module ThePirateBay
  class Torrent::Collection
    include Model
    
    ATTRS = [:id, :name, :seeders, :leechers, :magnet_uri,
      :size, :type, :uploaded_at, :comments_count, :uploader].freeze
    
    attr_accessor *ATTRS, :torrent
    
    def initialize(torrent)
      @torrent = torrent
      class_attributes.collect do |attr|
        self.public_send("#{attr}=", send(attr))
      end
    end
    
    def class_attributes
      ATTRS
    end

    def id
      torrent.css('td[2] div.detName').inner_html.match(/\/torrent\/(\d+)\//)[1]
    end
    
    def name
      torrent.css('td[2] div.detName a').text
    end
    
    def type
      torrent.css('td[1] a').map(&:text).join(" > ")
    end
    
    def size
      torrent.css('td[2] font.detDesc').text.match(/Size (.*),/)[1].gsub('i', '')
    end
    
    def seeders
      torrent.css('td[3]').text
    end
    
    def leechers
      torrent.css('td[4]').text
    end
    
    def uploader
      torrent.css('td[2] font.detDesc a').text
    end
    
    def magnet_uri
      torrent.css('td[2] div.detName + a').attribute("href").value
    end
    
    def comments_count
      unless (comments = torrent.css('td[2] img[@src*="comment.gif"]')).empty?
        comments.attribute("alt").value.match(/\d+/)[0]
      end
    end
    
    def uploaded_at
      torrent.css('td[2] font.detDesc').text.match(/Uploaded (.*),/)[1]
    end
    
  end # Torrent::Collection
end # ThePirateBay