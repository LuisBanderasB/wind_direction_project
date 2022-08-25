require "rest-client"
require "json"

def interpret_wind_diretcion(direction)
  case direction
  when "N"
    "North"
  when "NE"
    "Northeast"
  when "E"
    "East"
  when "SE"
    "Southeast"
  when "S"
    "South"
  when "SW"
    "Southwest"
  when "W"
    "West"
  when "NW"
    "Northwest"
  end
end

def get_wind_direction(longitude, latitude)
  timer_url = "http://www.7timer.info/bin/api.pl?lon=#{longitude}&lat=#{latitude}&product=civil&output=json"
  
  RestClient.get(timer_url) {| response |
    if response.code == 200
      result = JSON.parse response.to_str
      wind_direction = result["dataseries"][0]["wind10m"]["direction"]
      puts "The wind direction is: #{interpret_wind_diretcion(wind_direction)}"
    end
  }
end

def get_lat_and_long(zipcode)
  zippotam_url = "http://api.zippopotam.us/MX/#{zipcode}"

  RestClient.get(zippotam_url) {| response |
    if response.code == 200
      result = JSON.parse response.to_str
      longitude = result["places"][0]["longitude"]
      latitude = result["places"][0]["latitude"]

      get_wind_direction(longitude, latitude)
    end
  }
end

option = "y"

puts "Welcome to the wind direction searcher"
40.times {print "-"}
2.times {puts}

while (option == "y")
  print "Enter your zipcode: "
  zipcode = gets.chomp
  puts
  get_lat_and_long(zipcode)
  40.times {print "-"}
  2.times {puts}

  print "Do you want to enter another zipcode? [Y/N]: "
  option = gets.chomp.downcase
end