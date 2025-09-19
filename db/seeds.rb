unless User.exists?
  User.create!(username: "admin", password: "admin")
end