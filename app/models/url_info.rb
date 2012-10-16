class UrlInfo < ActiveRecord::Base
  attr_accessible :description, :image, :title, :og_type, :url
  has_many :clips
end
