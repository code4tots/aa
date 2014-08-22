require 'addressable/uri'
require 'rest-client'

url = Addressable::URI.new(
  scheme: 'http',
  host: 'localhost',
  port: 3000,
  path: '/users.html'
).to_s

puts RestClient.get(url)

url = Addressable::URI.new(
  scheme: 'http',
  host: 'localhost',
  port: 3000,
  path: '/users',
  query_values: {
    'some_category[a_key]' => 'another value',
    'some_category[a_second_key]' => 'yet another value',
    'some_category[inner_inner_hash][key]' => 'value',
    'something_else' => 'aaahhhhh'
  }
).to_s

puts RestClient.get(url, {'x' => 'y'})

def create_user
  url = Addressable::URI.new(
    scheme: 'http',
    host: 'localhost',
    port: 3000,
    path: '/users.json').to_s
  
  p(JSON::parse(RestClient.post(
    url,
    { user: {name: "Gizmo", email: "old email" } })))
end

id_val = create_user['id']

def create_invalid_user
  url = Addressable::URI.new(
    scheme: 'http',
    host: 'localhost',
    port: 3000,
    path: '/users.json').to_s
  
  puts RestClient.post(
    url,
    { user: {name: "Gizmo", email: "c" } })
end

# create_invalid_user

##### Update the user we just created above to have a different email
url = Addressable::URI.new(
  scheme: 'http',
  host: 'localhost',
  port: 3000,
  path: '/users/' + id_val.to_s).to_s

puts RestClient.patch(url, 'user[email]' => 'new email')

puts RestClient.get(url)

##### Delete the user we just created above with 'creat_user'
#####
url = Addressable::URI.new(
  scheme: 'http',
  host: 'localhost',
  port: 3000,
  path: '/users/' + id_val.to_s).to_s

# puts RestClient.get(url)

puts RestClient.delete(url)

