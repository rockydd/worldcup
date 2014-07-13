# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rank do
    name "MyString"
    user_id 1
    rank 1
    value 1.5
  end
end
