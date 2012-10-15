# -*- coding: utf-8 -*-
require 'spec_helper'

describe Support::SlideTagFilter do
  context 'filtering by og:type' do
    before do
      filter = Support::SlideTagFilter.new clip
      filter.filter
    end
    context 'the clip is slideshare type' do
      let(:clip){create(:slideshare)}
      subject{clip.tags}
      its(:length)    {should eq 1}
      describe 'the tag name is slide' do
        subject{clip.tags[0]}
        its("name")   {should eq 'slide'}
      end
    end
    context 'the clip is speakerdeck type' do
      let(:clip){create(:speakerdeck)}
      subject{clip.tags}
      its(:length)    {should eq 1}
      describe 'the tag name is slide' do
        subject{clip.tags[0]}
        its("name")   {should eq 'slide'}
      end
    end
    context 'the clip is not slideshare type' do
      let(:clip){create(:clip)}
      subject{clip.tags}
      its(:length)    {should eq 0}
    end
  end
end
