require 'spec_helper'

describe Tagging do
  before do
    @tagging = create(:tagging)
  end
  it 'shoud have relation' do
    @tagging.clip.should_not be_nil
  end
end
