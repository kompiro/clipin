# -*- coding: utf-8 -*-
require 'spec_helper'
require 'open-uri'

describe Clip do
  context 'attributes' do
    subject{Clip.new}
    its(:user)        {should be_nil}
    its(:pin)         {should be_false}
    its(:trash)       {should be_false}
  end
  context 'user' do
    before do
      @user = create(:user)
    end
    it 'should have user after saved',:filter => true do
      @clip = Clip.new(:url => 'http://example.com/')
      @clip.user = @user
      @clip.save
      @clip.user.should_not be_nil
    end
  end
  context 'tagging' do
    before do
      @user = create(:user)
      @clip = clip
      @clip.user = @user
      @clip.save
      @clip.tagging
    end
    context 'og_type tag' do
      let(:clip) {Clip.new(:url => 'http://example.com/', :og_type => 'website')}
      subject{@clip.tags}
      its(:length){should eq 1}
      it {subject[0].user.should == @user}
      it {subject[0].name.should == 'website'}
    end
    context 'slide tag' do
      let(:clip) {Clip.new(:url => 'http://example.com/', :og_type => 'slideshare:presentation')}
      subject{@clip.tags}
      its(:length){should eq 2}
      it {subject[0].user.should == @user}
      it {subject[0].name.should == 'slideshare:presentation'}
      it {subject[1].user.should == @user}
      it {subject[1].name.should == 'slide'}
    end
  end
  context 'search condition' do
    before do
      @user = create(:user)
      create_list(:clip,15,user: @user)
      create(:clip, pin: true, user: @user)
      create(:clip, trash: true, user: @user)
    end
    context 'pinned' do
      subject{Clip.pinned @user}
      its(:length){should eq 1}
    end
    context 'trashed' do
      subject{Clip.trashed @user}
      its(:length){should eq 1}
    end
  end
  context 'paging' do
    before do
      @user = create(:user)
      create_list(:clip,15,user: @user)
    end
    describe 'first page' do
      subject{Clip.page @user}
      its(:length){should eq 8}
    end
    describe 'second page' do
      subject{Clip.page(@user,2)}
      its(:length){should eq 7}
    end
    describe 'third page' do
      subject{Clip.page(@user,3)}
      its(:length){should eq 0}
    end
  end
  context 'search' do
    before do
      @user = create(:user)
      clip = create(:search_clip,user: @user)
    end
    subject {Clip.search @user,'test'}
    its(:length){should eq 1}
  end
end
