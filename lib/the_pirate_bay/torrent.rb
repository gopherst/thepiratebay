module ThePirateBay
  class Torrent < API
    include Model
    
    ATTRS_MAP = {
      :name             => "Title", 
      :description      => "Description", 
      :seeders          => "Seeders",
      :leechers         => "Leechers",
      :quality          => "Quality",
      :size             => "Size",
      :type             => "Type",
      :hash             => "Info Hash",
      :uploaded_at      => "Uploaded",
      :uploaded_by      => "By",
      :comments_count   => "Comments",
      :files_count      => "Files",
      :spoken_language  => "Spoken language(s)",
      :written_language => "Texted language(s)",
      :tags             => "Tag(s)",
      :imdb_id          => "Info"
    }.freeze
    
    ATTRS = [:id, *ATTRS_MAP.keys].freeze
    SKIP_ATTRS = [:hash, :tags, :imdb_id].freeze
    
    # Torrent attributes:
    #  id, name, description, seeders, leechers, hash, magnet_uri, quality, size, type,
    #  uploaded_at, uploaded_by, comments_count, files_count, spoken_language, written_language, imdb_id
    
    attr_accessor *ATTRS, :comments, :uploader, :html

    class << self
      
      # Public: Search for a torrent.
      #
      # Send your query as the only parameter, 
      # just like you would in ThePirateBay.se
      #
      # query - A string of keywords to search for.
      #
      # Examples
      #
      #    search("Fringe")
      #    search("Fringe s05e07")
      #
      # Returns an array of ThePirateBay::Torrent::Collection objects.
      def search(query)
        html = request("search/#{query}/0/99/0") # Returns search html

        # Get torrents table rows from html
        # and return as ruby objects
        html.xpath("//table[@id='searchResult']/tr").collect do |torrent_html|
          Torrent::Collection.new(torrent_html)
        end
      end
      
      # Public: Find a torrent by ID.
      #
      # Retrieve torrent information from ThePirateBay.se/torrent/:id
      #
      # id - The ID of the torrent.
      #
      # Examples
      #
      #    find("7723168")
      #    find(7723709)
      #
      # Returns an instance of ThePirateBay::Torrent
      def find(id)
        html = request("torrent/#{id}") # Returns torrent html
        
        # Initialize Torrent from html
        new(id, html)
      end
      alias :get :find
    end
    
    def initialize(id, html)
      # Save html doc to get special attributes
      @id, @html = id, html
      
      # Get attributes and values html lists
      attrs  = html.css("#details dt").map(&:text).map { |a| a.gsub(":", "") }
      values = html.css("#details dd").map(&:text)
      
      # Set instance attributes
      set_attributes(attrs, values)
      
      return self
    end
    
    # Set torrent attributes from html lists
    def set_attributes(attrs, values)
      attrs.zip(values).each do |dirty_attr, value|
        begin
          attr = attributes_map.key(dirty_attr) # Map to a nice and clean attribute name (see ATTRS_MAP)
          next if skip_attributes.include?(attr)
          value.sanitize! # Remove weird characters
          self.public_send("#{attr}=", value) unless value.empty?
        rescue NoMethodError => e
          raise e unless e.name == :"="
          raise UnknownAttributeError, "unknown attribute: #{dirty_attr}"
        end
      end
    end
    
    def name
      @name ||= html.css("div#title").text.sanitize!
    end
    
    def hash
      @hash ||= html.css("#details dd")[-1].next.text.strip
    end
    
    def description
      @description ||= html.css("div.nfo").text.strip
    end
    
    private
    
    def attributes_map
      ATTRS_MAP
    end
    
    def class_attributes
      ATTRS
    end
    
    def skip_attributes
      SKIP_ATTRS
    end
        
  end # Torrent
end # ThePirateBay