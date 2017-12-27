class Venue < ApplicationRecord

  def self.call_api(lat, lon, radius, section)
    date = self.get_date
    client = Foursquare2::Client.new(:client_id => '1XA3FP3VEHXNXDJSA1GMNDARTHHSZ2KJ5PLHKW0MBM50MFX0', 
            :client_secret => 'Y5ETOZQBBOZA5WJHAQEGNLIVBEGD0BGRTSZXUQPCBXQD0C30', 
            :api_version => date)
    ll = lat + ',' + lon
    client.explore_venues(:ll => ll, :radius=> radius, :section=> section, :limit => 100).groups[0]
  end

  def self.create_from_location(lat = '40.704069', lon = '-74.0132413', radius='1000', section='food')
    created_venues = []
    venue_data = self.call_api(lat, lon, radius, section)
    venue_data.items.each do |data|
      venue = Venue.find_or_create_by(
        name: data.venue.name,
        address:  data.venue.location.address,
        city:  data.venue.location.city,
        state: data.venue.location.state,
        postalCode:  data.venue.location.postalCode,
        lat:  data.venue.location.lat,
        lng:  data.venue.location.lng,
        category:  data.venue.categories[0].name,
        description:  data.venue.description,
        url:  data.venue.url
      )

      created_venues << venue
    end
    created_venues
  end

  def self.get_date
    year = Date.today.year
    month = Date.today.month
    day = Date.today.day
    date = [year, month, day].join('')
    date
  end
end