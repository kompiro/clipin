require 'forgery'

FactoryGirl.define do
  factory :tag do
    name {Forgery(:name).title}
    user
    created_at Time.now
    updated_at Time.now
  end
end

