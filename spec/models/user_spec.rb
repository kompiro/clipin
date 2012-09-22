require 'spec_helper'

describe User do
  context 'attributes' do
    subject {build(:user)}
    its(:uid) {should == '1234'}
    its(:provider) {should == 'facebook'}
    it {build(:user).valid?.should be_true}
  end
  context 'relations' do
    before do
      @user = create(:user_with_data)
    end
    it 'should have an id' do
      @user.id.should_not be_nil
    end
    context 'should relate clips' do
      subject {@user.clips}
      it{subject.should_not be_nil}
      its(:size){should == 5}
    end
  end
end
