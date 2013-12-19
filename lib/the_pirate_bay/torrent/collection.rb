module ThePirateBay
  class Torrent::Collection
    include Model

    ATTRS = [:id, :name, :seeders, :leechers, :magnet_uri,
      :size, :type, :uploaded_at, :uploaded_by, :comments_count].freeze

    attr_accessor *ATTRS, :html

    def initialize(html)
      @html = html # Save html to get instance attributes
      set_attributes

      return self
    end

    def set_attributes
      class_attributes.collect do |attr|
        self.public_send("#{attr}=", send(attr))
      end
    end

    def id
      @id ||= html.css('td[2] div.detName').inner_html.match(/\/torrent\/(\d+)\//)[1]
    end

    def name
      @name ||= html.css('td[2] div.detName a').text
    end

    def type
      @type ||= html.css('td[1] a').map(&:text).join(" > ")
    end

    def size
      @size ||= html.css('td[2] font.detDesc').text.match(/Size (.*),/)[1].gsub('i', '')
    end

    def seeders
      @seeders ||= html.css('td[3]').text
    end

    def leechers
      @leechers ||= html.css('td[4]').text
    end

    def magnet_uri
      @magnet_uri ||= html.css('td[2] div.detName + a').attribute("href").value
    end

    def uploaded_at
      @uploaded_at ||= html.css('td[2] font.detDesc').text.match(/Uploaded (.*), S/)[1]
    end

    def uploaded_by
      @uploaded_by ||= html.css('td[2] font.detDesc a').text
    end

    def comments_count
      @comments_count ||= unless (comments = html.css('td[2] img[@src*="comment.gif"]')).empty?
        comments.attribute("alt").value.match(/\d+/)[0]
      end
    end

    private

    def class_attributes
      ATTRS
    end

  end # Torrent::Collection
end # ThePirateBay
