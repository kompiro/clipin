FactoryGirl.define do
  factory :user do
    uid '1234'
    provider "facebook"
    created_at Time.now
    updated_at Time.now
    factory :user_with_data do
      ignore do
        clips_count 5
        tags_count 5
      end
      after(:create) do |user, evaluator|
        create_list(:clip, evaluator.clips_count,user: user)
        create_list(:tag, evaluator.tags_count, user: user)
      end
    end
  end
end
