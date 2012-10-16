require 'forgery'

FactoryGirl.define do
  factory :clip do
    title {Forgery(:name).title}
    image {"http://#{Forgery(:internet).domain_name}/"}
    url {"http://#{Forgery(:internet).domain_name}/"}
    user
    url_info
    created_at Time.now
    updated_at Time.now
    before(:create) do |clip|
      User.current = clip.user
    end
  end
  factory :slideshare, class: Clip do
    user
    association :url_info,factory: :slideshare_info
    created_at Time.now
    updated_at Time.now
    before(:create) do |clip|
      User.current = clip.user
    end
  end
  factory :speakerdeck, class: Clip do
    user
    association :url_info,factory: :speakerdeck_info
    created_at Time.now
    updated_at Time.now
    before(:create) do |clip|
      User.current = clip.user
    end
  end
  factory :search_clip , class: Clip  do
    user
    association :url_info, factory: :search_info
    created_at Time.now
    updated_at Time.now
    before(:create) do |clip|
      User.current = clip.user
    end
  end
end
