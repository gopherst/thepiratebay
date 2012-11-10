module ThePirateBay
  class Torrent < API
    include Model
    
    ATTRS = [:id, :name, :description, :seeders, :leechers, :hash, :magnet_uri, :quality, :size, :type, 
      :uploaded_at, :comments_count, :files_count, :spoken_language, :written_language, :imdb_id].freeze
    
    attr_accessor *ATTRS, :comments, :uploader, :tags

    class << self
      def search(query)
        # Returns search html
        doc = request("search/#{query}/0/99/0")

        # Get torrents table rows 
        # and return as ruby objects
        doc.xpath("//table[@id='searchResult']/tr").collect do |torrent|
          new(parse_search_result(torrent))
        end
      end
      
      def find(id)
        data = request("torrent/#{id}")
      end
      alias :get :find
      
      private
      
      def parse_search_result(torrent)
        {
          id:   torrent.css('td[2] div.detName').inner_html.match(/\/torrent\/(\d+)\//)[1],
          name: torrent.css('td[2] div.detName a').text,
          type: torrent.css('td[1] a').map(&:text).join(" > "),
          size: torrent.css('td[2] font.detDesc').text.match(/Size (.*),/)[1].gsub('i', ''),
          seeders:  torrent.css('td[3]').text,
          leechers: torrent.css('td[4]').text,
          uploader: torrent.css('td[2] font.detDesc a').text,
          magnet_uri: torrent.css('td[2] div.detName + a').attribute("href").value,
          comments_count: (torrent.css('td[2] img[@src*="comment.gif"]').attribute("alt").value.match(/\d+/)[0] rescue nil)
        }
      end
    end
    
  end # Torrent
end # ThePirateBay