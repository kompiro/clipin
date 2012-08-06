# -*- coding: utf-8 -*-
require 'spec_helper'
require 'open-uri'

describe Clip do
  fixtures :clips
  context 'attributes' do
    subject{Clip.new}
    its(:title)       {should be_nil}
    its(:og_type)     {should be_nil}
    its(:image)       {should be_nil}
    its(:description) {should be_nil}
    its(:url)         {should be_nil}
    its(:user)        {should be_nil}
    its(:pin)         {should be_false}
    its(:trash)       {should be_false}
  end
  context 'user' do
    before do
      User.current = create(:user)
      @clip = Clip.new(:url => 'http://example.com/')
      @clip.save
    end
    after do
      User.current = nil
    end
    it 'should be created' do
      User.current.should_not be_nil
    end
    it 'should have user after saved' do
      @clip.user.should_not be_nil
    end
  end
  context 'pinned' do
    subject{Clip.pinned}
    its(:length){should eq 1}
  end
  context 'trashed' do
    subject{Clip.trashed}
    its(:length){should eq 1}
  end
  context 'paging' do
    describe 'first page' do
      subject{Clip.page}
      its(:length){should eq 8}
    end
    describe 'second page' do
      subject{Clip.page(2)}
      its(:length){should eq 6}
    end
    describe 'third page' do
      subject{Clip.page(3)}
      its(:length){should eq 0}
    end
  end
end
