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
  factory :slideshare, class: Clip do
    title {Forgery(:name).title}
    image {"http://#{Forgery(:internet).domain_name}/"}
    url {"http://www.slideshare.net/#{Forgery(:name).title}/"}
    og_type 'slideshare:presentation'
    user
    created_at Time.now
    updated_at Time.now
    before(:create) do |clip|
      User.current = clip.user
    end
  end
  factory :speakerdeck, class: Clip do
    title {Forgery(:name).title}
    image {"https://speakerd.s3.amazonaws.com/presentations/4ff713abb5c1770021049c4b/thumb_slide_0.jpg"}
    url {"https://speakerdeck.com/u/#{Forgery(:name).title}/p/#{Forgery(:name).title}"}
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
