require 'spec_helper'

describe Tagging do
  fixtures :clips,:taggings,:tags
  it 'shoud have relation' do
    tagging = taggings(:taggings_001)
    tagging.clip.should_not be_nil
  end
end
