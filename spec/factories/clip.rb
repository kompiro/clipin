require 'forgery'

FactoryGirl.define do
  factory :clip do
    title {Forgery(:name).title}
    image {"http://#{Forgery(:internet).domain_name}/"}
    url {"http://#{Forgery(:internet).domain_name}/"}
    user
    created_at Time.now
    updated_at Time.now
    before(:create) do |clip|
      User.current = clip.user
    end
  end
  FactoryGirl.define do
    sequence :test_title do |n|
      "test #{n}"
    end
  end
  factory :search_clip , class: Clip  do
    title {FactoryGirl.generate :test_title}
    image {"http://#{Forgery(:internet).domain_name}/"}
    url {"http://#{Forgery(:internet).domain_name}/"}
    user
    created_at Time.now
    updated_at Time.now
  end
end
