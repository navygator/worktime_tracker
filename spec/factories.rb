FactoryGirl.define do
  factory :employee do
    sequence(:first_name)  { |n| "Person #{n}" }
    middle_name     ""
    last_name     "Hartl"
    sequence(:email) { |n| "person-#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    factory :admin do
      admin true
    end
  end
end