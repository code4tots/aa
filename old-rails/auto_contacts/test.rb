User.create!(username: "some-username")
p User.all

Contact.create!(name: 'person', email: '@', user_id: 1)
p Contact.all

p User.contacts

