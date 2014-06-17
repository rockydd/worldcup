# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_log do
    account_id 1
    change 1.5
    source 1
    description "MyString"
  end
end
