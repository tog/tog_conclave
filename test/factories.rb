Factory.define :user do |u|
  u.salt '7e3041ebc2fc05a40c60028e2c4901a81035d3cd'
  u.crypted_password '00742970dc9e6319f8019fd54864d3ea740f04b1'
  u.activation_code '8f24789ae988411ccf33ab0c30fe9106fab32e9a'
  u.state 'active'
  u.email {|a| "#{a.login}@example.com".downcase }
  u.admin {|a| a.admin }
end

Factory.define :event do |e|
  e.start_time (Time.now).to_formatted_s(:db)
  e.end_time (Time.now + 4.hour).to_formatted_s(:db)
  e.start_date (Date.today.to_time + 1.days).to_formatted_s(:db)
  e.end_date (Date.today.to_time + 2.days).to_formatted_s(:db)
  e.title 'title'
  e.description 'description'
  e.venue_link 'venue_link'
  e.venue_address 'Infinite Loop 1, 95014 Cupertino, CA'
  e.url 'url'
  e.capacity 100
  e.venue 'venue'
end
