require './calendar_builder'
require 'dotenv'
Dotenv.load

id = "resistanceupdates@gmail.com"
calendar = CalendarBuilder.build(id)

events = calendar.events

events.each do |event|
  puts "Event: #{event.summary}"
  puts "Description: #{event.description}"
  puts "Location: #{event.location}"
  puts "Lat: #{event.lat}"
  puts "Lng: #{event.lng}"
  puts "Timestamp: #{event.timestamp}"
  puts "Humanized Time: #{event.humanized_time}"
  puts "----------------------"
end

puts calendar.as_geojson

