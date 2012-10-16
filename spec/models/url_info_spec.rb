require 'spec_helper'

describe UrlInfo do
  describe 'attributes' do
    its(:title)       {should be_nil}
    its(:og_type)     {should be_nil}
    its(:image)       {should be_nil}
    its(:description) {should be_nil}
    its(:url)         {should be_nil}
  end
end
