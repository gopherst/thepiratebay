module ThePirateBay
  class Torrent < HyperAPI::Base
    extend Connection

    integer id: 'a[title=Files]' do
      attribute('href').value.match(/(\d+)\/$/)[1]
    end

    string name: 'div#title' do
      text.sanitize!
    end

    string magnet_uri: 'div.download a' do
      attribute('href').value
    end

    string hash: '#details dd' do
      last.next.text.strip
    end

    string description: 'div.nfo' do
      text.strip
    end

    string imdb_id: '#details dd a[title=IMDB]' do
      attribute('href').value.match(/\/(\w+)\/$/)[1]
    end

    OPTIONAL_ATTRS = {
      :seeders          => 'Seeders',
      :leechers         => 'Leechers',
      :quality          => 'Quality',
      :size             => 'Size',
      :type             => 'Type',
      :uploaded_at      => 'Uploaded',
      :uploaded_by      => 'By',
      :comments_count   => 'Comments',
      :files_count      => 'Files',
      :spoken_language  => 'Spoken language(s)',
      :written_language => 'Texted language(s)',
      :tags             => 'Tag(s)',
    }

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
      #    search('Fringe')
      #    search('Fringe s05e07')
      #
      # Returns an array of ThePirateBay::Torrent::Collection objects.
      def search(query)
        uri = 'search/' + CGI::escape(query)
        html = request(uri) # Returns search html

        # Get torrents table rows from html
        # and return as ruby objects
        html.css('#searchResult tr')[1..-1].collect do |torrent_html|
          Torrent::Collection.new(torrent_html.to_s)
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
      #    find('7723168')
      #    find(7723709)
      #
      # Returns an instance of ThePirateBay::Torrent
      def find(id)
        html = request("torrent/#{id}") # Returns torrent html
        new(html)
      end
      alias :get :find
    end

    def initialize(html)
      opt_attrs = html.css('#details dt').map(&:text).map { |a| a.gsub(':', '') }
      values = html.css('#details dd').map(&:text)

      set_optional_attributes(opt_attrs, values)

      super(html.to_s)
    end

    def set_optional_attributes(opt_attrs, values)
      opt_attrs.zip(values).each do |opt_attr, value|
        attr = OPTIONAL_ATTRS.key(opt_attr) or next
        instance_variable_set("@#{attr}", value.sanitize!)

        self.class.send :define_method, attr do
          instance_variable_get("@#{attr}")
        end
      end
    end

  end # Torrent
end # ThePirateBay
