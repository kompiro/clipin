require 'spec_helper'

describe Tag do
  context 'attributes before created' do
    subject{Tag.new}
    its(:name)       {should be_nil}
    its(:user)       {should be_nil}
    its(:color)      {should == 0}
  end
  context 'attributes after created' do
    before do
      @tag = create(:tag)
    end
    subject{@tag}
    its(:name)       {should_not be_nil}
    its(:user)       {should_not be_nil}
    its(:color)      {should == 3}
  end

  context 'relation' do
    before do
      @tag = create(:tagging).tag
    end
    it 'should relate taggings' do
      @tag.taggings.size.should eq 1
    end
    it 'should relate user' do
      @tag.user.should_not be_nil
    end
    it 'should relate clips' do
      @tag.clips.size.should eq 1
    end
  end
end
