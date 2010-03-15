#
#
#
#
require 'net/http'
require 'xmlsimple'
require 'cgi'
require 'json'

# Oodle Module
module Oodle
  
  REGIONS_URL = "http://developer.oodle.com/files/xml/oodle_regions.xml"
  CATEGORIES_URL = "http://developer.oodle.com/files/xml/oodle_categories.xml"  
  
  VERSION_URLS = {:v2=>"http://api.oodle.com/api/v2/listings"}
  RESPONSE_FORMATS = {
    :xml=>'xml', # - output is formatted in plain old XML
    :json=>'json', # - output is fromatted in JSON (JavaScript Object Notation)
    :php_serial=>'php_serial', # - output structure formatted in serialized PHP
    :php_export=>'php_export', # - output structure formatted as valid PHP
    :dump=>'dump', # - output is dumped with no formatting
    :rss2=>'rss2' # - listing information returned in RSS 2.0 format
  }
  
  SORT_VALUES = {
    :ctime=>'ctime',# - by listing's creation time - oldest to newest
    :ctime_reverse=>'ctime_reverse',# - by listing's creation time, reverse order - newest to oldest
    :distance=>'distance',# - by distance from "location" value above - closest to farthest
    :distance_reverse=>'distance_reverse',# - by distance from "location" parameter, reverse order - farthest to closest
    :eventdate=>'eventdate',# - by date of event (e.g. tickets listings) - in chronological order
    :eventdate_reverse=>'eventdate_reverse',# - by date of event - in reverse chronological order
    :price=>'price',# - by listing's price - lowest to highest
    :price_reverse=>'price_reverse' # - by listing's price, reverse order - highest to lowest
  }
    
  
  #
  #
  #
  # Oodle Class
  #
  class API
    attr_accessor :key, :region, :q, :category, :attributes, :location, :radius, :start, :num, :sort, :refinements, :ctime_low, :ctime_high, :exclude_sources, :assisted_search, :format, :jsoncallback, :fetched, :version
    
    def initialize(key,version)
      @key = key
      @version = version if version
      @version = :v2 unless version
      @attributes = []
      @refinements = []
      @exclude_sources = []
      @format = RESPONSE_FORMATS[:xml]
    end
    
    # A convience method to do actual http pulls
    # Notice that there is not any exception trapping
    def http_pull(dest_url)
      res = Net::HTTP.get_response(URI.parse(dest_url))
      self.fetched = res.body
    end
    
    # Requires version be set
    # Build the url from the state of the current self
    def build_url
      url = VERSION_URLS[self.version]
      url += "?" unless url && url[-1] == '?'
      # must CGI escape each param value
      url = "#{url}key=#{CGI::escape(self.key)}"
      url = "#{url}&region=#{CGI::escape(self.region)}" if self.region
      url = "#{url}&category=#{CGI::escape(self.category)}" if self.category
      url = "#{url}&q=#{CGI::escape(self.q)}" if self.q
      url = "#{url}&attributes=#{CGI::escape(self.attributes_as_string)}" if self.attributes.size > 0
      url = "#{url}&location=#{CGI::escape(self.location)}" if self.location
      url = "#{url}&radius=#{CGI::escape(self.radius)}" if self.radius
      url = "#{url}&start=#{CGI::escape(self.start)}" if self.start
      url = "#{url}&num=#{CGI::escape(self.num)}" if self.num
      url = "#{url}&sort=#{CGI::escape(self.sort)}" if self.sort
      url = "#{url}&refinements=#{CGI::escape(self.refinements_as_string)}" if self.refinements.size > 0
      url = "#{url}&ctime_low=#{CGI::escape(self.ctime_low)}" if self.ctime_low
      url = "#{url}&ctime_high=#{CGI::escape(self.ctime_high)}" if self.ctime_high
      url = "#{url}&exclude_sources=#{CGI::escape(self.exclude_sources_as_string)}" if self.exclude_sources.size > 0
      url = "#{url}&assisted_search=#{CGI::escape(self.assisted_search)}" if self.assisted_search
      url = "#{url}&format=#{CGI::escape(self.format)}&jsoncallback=none" if self.format
      url
    end

# THESE CAN BE REFACTORED INTO SOMETHING MORE META-LIKE
    def exclude_sources_as_string
      res = ""
      res = self.exclude_sources.join(',') if self.exclude_sources.size > 0
      res
    end

    def refinements_as_string
      res = ""
      res = self.refinements.join(',') if self.refinements.size > 0
      res
    end
    
    def attributes_as_string
      res = ""
      res = self.attributes.join(',') if self.attributes.size > 0
      res
    end
# -----------------------    
    
=begin
  xml - output is formatted in plain old XML
  json - output is fromatted in JSON (JavaScript Object Notation)
  php_serial - output structure formatted in serialized PHP
  php_export - output structure formatted as valid PHP
  dump - output is dumped with no formatting
  rss2 - listing information returned in RSS 2.0 format
=end    
    def fetch_raw(format=nil)
      @format = RESPONSE_FORMATS[format] if format
      http_pull(build_url)
    end

    # Returns an array of listings based on the last fetch 
    # if fetch is empty then will trigger a fetch
    def fetch_listings(format=nil)
      result = nil
      raw = fetch_raw(format)
      case self.format
      when 'xml'
        # parse xml raw
        result = XmlSimple.xml_in raw, { 'ForceArray' => false, 'AttrPrefix' => true }
      when 'json'
        result = JSON.parse(raw)
      when 'php_serial'
        # return raw
      when 'php_export'
        # return raw
      when 'dump'
        # return raw
      when 'rss2'
        # TODO parse rss2 raw
      end
      result = raw unless result
      result
    end
    
    def fetch_categories(raw=false)
      xml = http_pull(CATEGORIES_URL)
      if raw
        xml
      else
        # parse into objects
        XmlSimple.xml_in xml, { 'ForceArray' => false, 'AttrPrefix' => true }
      end
    end
    
    def fetch_regions(raw=false)
      xml = http_pull(REGIONS_URL)
      if raw
        xml
      else
        # parse into objects
        XmlSimple.xml_in xml, { 'ForceArray' => false, 'AttrPrefix' => true }
      end
    end
    
  end
  
end