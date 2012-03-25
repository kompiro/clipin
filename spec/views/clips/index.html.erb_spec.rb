require 'spec_helper'

describe "clips/index" do
  before(:each) do
    assign(:clips, [
      stub_model(Clip,
        :title => "MyText",
        :type => "Type",
        :image => "MyText",
        :url => "MyText",
        :description => "MyText",
        :audio => "MyText",
        :video => "MyText"
      ),
      stub_model(Clip,
        :title => "MyText",
        :type => "Type",
        :image => "MyText",
        :url => "MyText",
        :description => "MyText",
        :audio => "MyText",
        :video => "MyText"
      )
    ])
  end

  it "renders a list of clips" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
