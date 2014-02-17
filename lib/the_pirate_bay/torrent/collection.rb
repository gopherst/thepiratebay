module ThePirateBay
  class Torrent::Collection < HyperAPI::Base

    integer id: '.detName a' do
      attribute('href').value.match(/\/torrent\/(\d+)\//)[1]
    end

    string name: '.detName a'

    string magnet_uri: '.detName + a' do
      attribute('href').value
    end

    integer seeders: 'td[3]'

    integer leechers: 'td[4]'

    string size: 'font.detDesc' do
      text.match(/Size (.*),/)[1].gsub('i', '')
    end

    string type: 'td[1] a' do
      map(&:text).join(' > ')
    end

    string uploaded_at: 'font.detDesc' do
      text.match(/Uploaded (.*), S/)[1]
    end

    string uploaded_by: 'font.detDesc a'

    integer comments_count: 'img[@src*="comment.gif"]' do
      attribute('alt').value.match(/\d+/)[0]
    end

  end
end
