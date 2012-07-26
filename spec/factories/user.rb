FactoryGirl.define do
  factory :user do
    id 1
    uid '1234'
    provider "facebook"
  end
end
