require 'spec_helper'

describe "clips/index" do
  before(:each) do
    assign(:clips, [
      stub_model(Clip,
        :title => "MyText",
        :og_type => "Type",
        :image => "MyText",
        :url => "MyText",
        :description => "MyText"
      ),
      stub_model(Clip,
        :title => "MyText",
        :og_type => "Type",
        :image => "MyText",
        :url => "MyText",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of clips" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select ".title", :text => "MyText".to_s, :count => 2
    assert_select ".description", :text => "MyText".to_s, :count => 2
    assert_select ".og_type", :text => "Type".to_s, :count => 2
  end
end
