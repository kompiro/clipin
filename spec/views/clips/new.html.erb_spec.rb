require 'spec_helper'

describe "clips/new" do
  before(:each) do
    assign(:clip, stub_model(Clip,
      :title => "MyText",
      :type => "",
      :image => "MyText",
      :url => "MyText",
      :description => "MyText",
      :audio => "MyText",
      :video => "MyText"
    ).as_new_record)
  end

  it "renders new clip form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => clips_path, :method => "post" do
      assert_select "textarea#clip_title", :name => "clip[title]"
      assert_select "input#clip_type", :name => "clip[type]"
      assert_select "textarea#clip_image", :name => "clip[image]"
      assert_select "textarea#clip_url", :name => "clip[url]"
      assert_select "textarea#clip_description", :name => "clip[description]"
      assert_select "textarea#clip_audio", :name => "clip[audio]"
      assert_select "textarea#clip_video", :name => "clip[video]"
    end
  end
end
