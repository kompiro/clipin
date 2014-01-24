require 'spec_helper'
require 'requests/helpers'

describe "Clips" do
  describe "GET /clips" do
    describe "unauthorized" do
      before do
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      end
      it "works! (now write some real specs)" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        visit "/auth/facebook"
        visit clips_path
        expect(page).to have_content('facebookでログイン')
      end
    end
    describe "authorized" do
      before do
        mock_auth
      end
      it "works! (now write some real specs)" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        visit "/auth/facebook"
        visit clips_path
        expect(page).not_to have_content('facebookでログイン')
      end
    end
  end
end
