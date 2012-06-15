namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(first_name: "Admin",
                    middle_name: "Test",
                    last_name: "User",
                    email: "example@railstutorial.org",
                    password: "foobar",
                    password_confirmation: "foobar")
    admin.toggle!(:admin)

    99.times do |n|
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = "example-#{n}@railstutorial.org"
      password = "password"
      User.create!(first_name: first_name,
                       last_name: last_name,
                       email: email,
                       password: password,
                       password_confirmation: password)
    end
  end
end