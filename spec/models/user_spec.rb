require 'spec_helper'

describe User do
  context 'attributes' do
    subject {build(:user)}
    its(:uid) {should == '1234'}
    its(:provider) {should == 'facebook'}
    it {build(:user).valid?.should be_true}
  end
  it {create(:user).id.should_not be_nil}
end
