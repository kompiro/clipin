# Read about factories at https://github.com/thoughtbot/factory_girl
require 'forgery'

FactoryGirl.define do
  factory :url_info do
    title {Forgery(:name).title}
    image {"http://#{Forgery(:internet).domain_name}/"}
    url {"http://#{Forgery(:internet).domain_name}/"}
    og_type ""
    description "description"
  end
  factory :slideshare_info, class: UrlInfo do
    title {Forgery(:name).title}
    image {"http://#{Forgery(:internet).domain_name}/"}
    url {"http://#{Forgery(:internet).domain_name}/"}
    og_type "slideshare:presentation"
    description "description"
  end
  factory :speakerdeck_info, class: UrlInfo do
    title {Forgery(:name).title}
    image {"https://speakerd.s3.amazonaws.com/presentations/4ff713abb5c1770021049c4b/thumb_slide_0.jpg"}
    url {"https://speakerdeck.com/u/#{Forgery(:name).title}/p/#{Forgery(:name).title}"}
    og_type ""
    description "description"
  end
  factory :search_info, class: UrlInfo do
    title {FactoryGirl.generate :test_title}
    image {"http://#{Forgery(:internet).domain_name}/"}
    url {"http://#{Forgery(:internet).domain_name}/"}
    og_type "website"
    description "description"
  end
  FactoryGirl.define do
    sequence :test_title do |n|
      "test #{n}"
    end
  end
end
