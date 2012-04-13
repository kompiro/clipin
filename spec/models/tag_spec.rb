require 'spec_helper'

describe Tag do
  fixtures :clips,:taggings,:tags
  context 'attributes' do
    subject{Tag.new}
    its(:name)       {should be_nil}
  end

  context 'relation' do
    before do
      @tag = tags(:tags_001)
    end
    it 'should relate taggings' do
      @tag.taggings.size.should eq 1
    end
    it 'should relate clips' do
      @tag.clips.size.should eq 1
    end
  end
end
