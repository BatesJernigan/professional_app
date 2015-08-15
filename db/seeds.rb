User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "keytothecastle",
             password_confirmation: "keytothecastle",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "anotherkeytothecastle"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end
