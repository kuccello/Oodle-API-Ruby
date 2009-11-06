require File.dirname(__FILE__) + '/test-helper'

class OodleAPITest < Test::Unit::TestCase
  
  def setup
    @oodle = Oodle::API.new('625C7AB37B12',:v2)
    @oodle.region = 'usa'
    @oodle.q = "paintball"
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
    listings_xml = @oodle.fetch_listings(:xml)
    assert_not_nil(listings_xml,"Listings XML as object should not be nil")
    listings_json = @oodle.fetch_listings(:json)
    assert_not_nil(listings_json,"Listings JSON as object should not be nil")
    listings_dump = @oodle.fetch_listings(:dump)
    assert_not_nil(listings_dump,"Listings DUMP as object should not be nil")
  end

end
