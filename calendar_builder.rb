require './calendar'
require './event'
require 'open-uri'
require 'ostruct'
require 'googleauth'
require 'google/apis/calendar_v3'

class CalendarBuilder
  SCOPES = [Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY].freeze

  def initialize(calendar_id)
    @calendar_id = calendar_id
  end

  def calendar
    @calendar ||= build_calendar(@calendar_id)
  end

  def self.build(id)
    new(id).calendar
  end

  private

  # TODO: refactor into object
  def build_calendar(id)
    events = []
    page_token = nil
    loop do
      response = calendar_service.list_events(id,
                                              page_token: page_token)

      events += response.items.map { |item|
        Event.new(item)
      }
      break unless response.next_page_token
      page_token = response.next_page_token
    end
    Calendar.new(events)
  end

  # TODO: refactor this stuff into an object
  def calendar_service
    @calendar_service ||= build_calendar_service
  end

  def build_calendar_service
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = auth
    service
  end

  def auth
    Google::Auth.get_application_default(SCOPES)
  end
end
