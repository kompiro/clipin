require 'spec_helper'

describe "tags/index" do
  before(:each) do
    assign(:tags, [
      stub_model(Tag,
        :name => "Name",
        :clip_id => 1
      ),
      stub_model(Tag,
        :name => "Name",
        :clip_id => 1
      )
    ])
  end

  it "renders a list of tags" do
    render
  end
end
