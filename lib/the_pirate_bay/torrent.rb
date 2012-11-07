module ThePirateBay
  class Torrent < API
    include Model
    
    ATTRS = [:id, :name, :description, :seeders, :leechers, :hash, :magnet_uri, :quality, :size, :type, 
      :uploaded_at, :comments_count, :files_count, :spoken_language, :written_language, :imdb_id].freeze
    
    attr_accessor *ATTRS, :comments, :uploader, :tags

    class << self
      def search(query)
        data = request("search/#{query}/0/99/0")
      end
      
      def find(id)
        data = request("torrent/#{id}")
      end
      alias :get :find
    end
            
  end # Torrent
end # ThePirateBay