require 'spec_helper'

describe "clips/show" do
  before(:each) do
    @clip = assign(:clip, stub_model(Clip,
      :title => "MyText",
      :type => "Type",
      :image => "MyText",
      :url => "MyText",
      :description => "MyText",
      :audio => "MyText",
      :video => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/Type/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
  end
end
