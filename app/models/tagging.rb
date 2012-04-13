class Tagging < ActiveRecord::Base
  belongs_to :clip
  belongs_to :tag
end
