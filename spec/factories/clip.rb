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
      created_at Time.parse '2012/10/31'
      updated_at Time.parse '2012/10/31'
    end
    factory :trashed_clip do
      trash true
    end
    factory :pinned_clip do
      pin true
    end
  end
end
