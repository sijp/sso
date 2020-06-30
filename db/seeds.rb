# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all
Client.delete_all
UrlWhitelist.delete_all

User.create(name: "Shlomi", email: "shlomi@email.com", password: "123456")
client = Client.create(name: "sso-client", client_id: "q1w2e3", client_secret: "abcd1234")
UrlWhitelist.create(url: "http://localhost:5000", client: client)
