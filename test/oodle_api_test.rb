require File.dirname(__FILE__) + '/test-helper'

class OodleAPITest < Test::Unit::TestCase
  
  def setup
    @oodle = Oodle::API.new('TEST')
    @oodle.region = 'usa'
    @oodle.q = "sale"
    @oodle.num = '5'
  end
  
  def teardown
  end

  def test_fetch_categories
  
    categories = @oodle.fetch_categories
    assert_not_nil(categories,"categories as object should not be nil")
    categories_raw = @oodle.fetch_categories(true)
    assert_not_nil(categories_raw,"categories_raw as object should not be nil")

  end
  
  def test_fetch_regions
    
    regions = @oodle.fetch_regions
    assert_not_nil(regions,"Regions as object should not be nil")
    
    regions = @oodle.fetch_regions(true)
    assert_not_nil(regions,"Regions as object should not be nil")
  end
  
  def test_fetch_listings_with_default_query
   
    listings = @oodle.fetch_listings
    assert_not_nil(listings,"Listings as object should not be nil")
    assert listings['meta']['returned'].to_i > 0

    listings_xml = @oodle.fetch_listings(:xml)
    assert_not_nil(listings_xml,"Listings XML as object should not be nil")
    assert listings_xml['meta']['returned'].to_i > 0

    listings_json = @oodle.fetch_listings(:json)
    assert_not_nil(listings_json,"Listings JSON as object should not be nil")
    assert listings_json['meta']['returned'].to_i > 0

    listings_dump = @oodle.fetch_listings(:dump)
    assert_not_nil(listings_dump,"Listings DUMP as object should not be nil")
  end

  def test_missing_api_key
    @oodle.key = nil

    assert_raise ArgumentError do
      @oodle.fetch_listings
    end

    @oodle.key = ''

    assert_raise ArgumentError do
      @oodle.fetch_listings
    end
  end

  def test_missing_region
    @oodle.region = nil

    assert_raise ArgumentError do
      @oodle.fetch_listings
    end

    @oodle.region = ''

    assert_raise ArgumentError do
      @oodle.fetch_listings
    end
  end

  def test_missing_category_and_query
    @oodle.category = nil
    @oodle.q = nil

    assert_raise ArgumentError do
      @oodle.fetch_listings
    end

    @oodle.category = ''
    @oodle.q = ''

    assert_raise ArgumentError do
      @oodle.fetch_listings
    end
  end
end
