Factory.define :user do |u|
  u.login { random_string }
  u.salt '7e3041ebc2fc05a40c60028e2c4901a81035d3cd'
  u.crypted_password '00742970dc9e6319f8019fd54864d3ea740f04b1'
  u.activation_code '8f24789ae988411ccf33ab0c30fe9106fab32e9a'
  u.state 'pending'
  u.email { random_email_address }
end

Factory.define :event do |e|
  e.start_time { Time.now }
  e.end_time { Time.now + 4.hour }
  e.start_date { Date.today.to_time + 1.days }
  e.end_date { Date.today.to_time + 2.days }
  e.title { random_string }
  e.description { random_string }
  e.venue_link { random_string }
  e.venue_address { random_string }
  e.url { random_string }
  e.capacity 100
  e.venue { random_string }
  e.association :owner, :factory => :user
end

def random_string
  letters = *'a'..'z'
  random_string_for_uniqueness = ''
  10.times { random_string_for_uniqueness += letters[rand(letters.size - 1)]}
  random_string_for_uniqueness
end
def random_email_address
  "#{random_string}@example.com"
end