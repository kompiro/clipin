require 'spec_helper'
require 'requests/helpers'

describe "Clips" do
  describe "GET /clips" do
    describe "unauthorized" do
      it "works! (now write some real specs)" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        visit "/auth/facebook"
        get clips_path
        response.status.should be(302)
      end
    end
    describe "authorized" do
      before do
        mock_auth
        visit "/auth/facebook"
      end
      it "works! (now write some real specs)" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        get clips_path
        response.status.should be(200)
      end
    end
  end
end
