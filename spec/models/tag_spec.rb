require 'spec_helper'

describe Tag do
  context 'attributes' do
    subject{Tag.new}
    its(:name)       {should be_nil}
  end

  context 'relation' do
    before do
      @tag = create(:tagging).tag
    end
    it 'should relate taggings' do
      @tag.taggings.size.should eq 1
    end
    it 'should relate clips' do
      @tag.clips.size.should eq 1
    end
  end
end
