def user(i)
  user = User.find_by_id(i)
  user = User.create!(id: i, username: "user#{i}") if user.nil?
  user
end

def contact(user_id, email=nil, name=nil)
  options = {
    user_id: user(user_id).id,
    email: email.nil? ? "user#{user_id}@email" : email,
    name: name.nil? ? "user#{user_id}" : name}
  
  contact = Contact.find_by(options)
  contact = Contact.create!(options) if contact.nil?
  contact
end

def contact_share(user, contact)
  options = {
    user_id: user.id,
    contact_id: contact.id}
  
  share = ContactShare.find_by(options)
  share = ContactShare.create!(options) if share.nil?
  share
end

user(1)
contact(1)
contact_share(user(2), contact(1))
contact_share(user(3), contact(1))
p user(2).contact_shares
p user(2).contacts
p contact(1).shared_users
