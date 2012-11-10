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
          Torrent::Collection.new(torrent)
        end
      end
      
      def find(id)
        data = request("torrent/#{id}")
      end
      alias :get :find
    end
    
  end # Torrent
end # ThePirateBay