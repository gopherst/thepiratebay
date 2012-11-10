# ThePirateBay [![Build Status](https://secure.travis-ci.org/jassa/the_pirate_bay.png?branch=master)](https://travis-ci.org/jassa/the_pirate_bay) [![Dependency Status](https://gemnasium.com/jassa/the_pirate_bay.png)](https://gemnasium.com/jassa/the_pirate_bay) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jassa/the_pirate_bay)

Ruby Client for ThePirateBay.se

## Installation

    $ gem install the_pirate_bay

Or add this line to your application's Gemfile:

    gem 'the_pirate_bay'

And then execute:

    $ bundle

## Usage

```ruby
require "the_pirate_bay"

api = ThePirateBay.new

# You can search for a torrent by keyword
api.series.search("Fringe")
=> [#<ThePirateBay::Torrent::Collection id: "7810640", name: "Fringe S05E06 Season 5 Episode 6 HDTV x264 [GlowGaz...", seeders: "408", leechers: "116", magnet_uri: "magnet:?xt=urn:btih:0f4e3c1a4618b6d9658427e7778c602...", size: "303.89 MB", type: "Video > TV shows", uploaded_at: "Today 04:11, Size 303.89 MiB", comments_count: "2", uploader: "GlowGaze">]

# Once you have a torrent id, you can use it to find more information
torrent = api.torrents.find("7810640")
```

## Work in Progress

* Find torrents by id
* Handle users
* Sort results by relevance, seeders, leechers, size, date, user and type
* Get results from other pages

## Motivation

ThePirateBay.se is a very powerful engine, and it requires a powerful and specialized gem that can handle all it has to offer, seamlessly.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Javier Saldana. See LICENSE for details.
