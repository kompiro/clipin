require 'forgery'

FactoryGirl.define do
  factory :tagging do
    clip
    tag
    created_at Time.now
    updated_at Time.now
  end
end

