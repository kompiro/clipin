# -*- coding: utf-8 -*-
require 'spec_helper'

describe Support::OgTypeTagFilter do
  context 'filtering by og:type' do
    before do
      filter = Support::OgTypeTagFilter.new clip
      filter.filter
    end
    context 'the clip is slideshare type' do
      let(:clip){create(:slideshare)}
      subject{clip.tags}
      its(:length)    {should eq 1}
      describe 'the tag name is slideshare:presentation' do
        subject{clip.tags[0]}
        its("name")   {should eq 'slideshare:presentation'}
      end
    end
    context "The clip hasn't set og_type" do
      let(:clip){create(:clip)}
      subject{clip.tags}
      its(:length)    {should eq 0}
    end
  end
end
