FactoryGirl.define do
  factory :employee do
    first_name     "Michael"
    middle_name     ""
    last_name     "Hartl"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end