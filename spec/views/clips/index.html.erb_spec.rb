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
  end
end
