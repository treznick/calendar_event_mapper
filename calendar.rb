require 'rgeo-geojson'
require 'rgeo'
require 'json'

class Calendar
  attr_reader :events

  def initialize(events)
    @events = events
    geocode_events
  end

  def feature_collection
    @feature_collection ||= RGeo::GeoJSON::EntityFactory.
      new.
      feature_collection(@events.map(&:rgeo_object))
  end

  def as_geojson
    @geojson ||= RGeo::GeoJSON.encode(feature_collection)
  end

  def to_geojson
    as_geojson.to_json
  end

  private

  def geocode_events
    @events.each(&:geocode!)
  end
end
