require 'forgery'

FactoryGirl.define do
  factory :clip do
    user
    url_info
    created_at Time.now
    updated_at Time.now
    factory :slideshare do
      association :url_info,factory: :slideshare_info
    end
    factory :speakerdeck do
      association :url_info,factory: :speakerdeck_info
    end
    factory :search_clip do
      association :url_info, factory: :search_info
    end
  end
end
