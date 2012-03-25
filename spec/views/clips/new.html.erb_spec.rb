require 'spec_helper'

describe "clips/new" do
  before(:each) do
    assign(:clip, stub_model(Clip,
      :title => "MyText",
      :og_type => "",
      :image => "MyText",
      :url => "MyText",
      :description => "MyText"
    ).as_new_record)
  end

  it "renders new clip form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => clips_path, :method => "post" do
      assert_select "input#clip_url", :name => "clip[url]"
    end
  end
end
