# Oodle Ruby API
---

## Description

Oodle is an online classifieds service. By using this client for the [Oodle
API](http://developer.oodle.com/), you can add classified listings to your own site. You can filter
listings by category, region, and keywords. You will need to request an [API
key](http://developer.oodle.com/request-api-key) to get started.

## Installation

    gem install oodle

## Example

    require 'rubygems'
    require 'oodle'
    
    API_KEY = '??????' # Request your API key at http://developer.oodle.com/request-api-key
    
    oodle = Oodle::API.new(API_KEY)
    oodle.region = 'chicago'
    oodle.category = 'sale'
    oodle.num = '15'
    oodle.sort = 'ctime_reverse'
    results = oodle.fetch_listings(:json)
    num = results['current']['num']
    listings = results['listings']
    (0..num-1).each { |i| p listings[i]['title'] }

## Dependencies

* xml-simple gem
* json gem

## License

This software is licensed using the MIT License (see LICENSE for details).
