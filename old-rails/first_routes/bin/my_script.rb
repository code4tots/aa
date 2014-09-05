#bin/my_script.rb
require 'addressable/uri'
require 'rest-client'
url = Addressable::URI.new(
  scheme: 'http',
  host: 'localhost',
  port: 3000,
  path: '/users'#,
 # path: '/users.html'#,
 # query_values: {
 #   'a' => 'b',
 #   'b[a]' => 'c'
 # }
).to_s

puts RestClient.get(url)

# puts RestClient.post(
#  url,
#  { user: { name: "Gizmo", email: "gzmo@gizmo.gizmo" } }
# )

# puts RestClient.patch(
#   url,
#   { user: { name: "some-name"} })

# puts RestClient.delete(url)