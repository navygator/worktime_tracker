FactoryGirl.define do
  factory :employee do
    first_name     "Michael"
    middle_name     ""
    last_name     "Hart"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end