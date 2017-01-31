require 'forwardable'
require 'rgeo'
require 'rgeo-geojson'
require 'geocoder'

class Event
  extend Forwardable

  def_delegators :@calendar_event, :location, :summary, :description
  def_delegator :@calendar_event, :start

  attr_accessor :lat, :lng

  def initialize(calendar_event, geocoder_class=Geocoder)
    @calendar_event = calendar_event
    @geocoder_class = geocoder_class
  end

  def geocode!
    @lat, @lng = %i(latitude longitude).map { |method|
      geocoder_results.first.__send__(method)
    }
  end

  def rgeo_object
    @rgeo_object ||= RGeo::GeoJSON::EntityFactory.new.feature(rgeo_point,
                                                          nil,
                                                          geojson_properties)
  end

  def timestamp
    start.date_time.to_s
  end

  def humanized_time
    DateTime.parse(timestamp).strftime("%m/%d/%y %I:%M%p %Z")
  end

  private

  def rgeo_point
    @rgeo_point ||= RGeo::Geographic.spherical_factory(srid: 4326).point(lng, lat)
  end

  def geojson_properties
    {
      location: location,
      summary: summary,
      description: description,
      when: humanized_time
    }
  end

  def geocoder_results
    @geocoder_results ||= @geocoder_class.search(location)
  end
end
