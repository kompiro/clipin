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
    it 'should have user after saved' do
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
      @tagged_clip = create(:clip, user: @user)
      @tag = create(:tag,user: @user)
      @date = Time.parse('2012/11/02')
      create(:clip, updated_at: @date, user: @user)
      tagging = create(:tagging,tag: @tag,clip: @tagged_clip)
    end
    context 'pinned' do
      subject{Clip.pinned}
      its(:length){should eq 1}
      it 'should be pinned' do
        subject[0].pin.should be_true
      end
    end
    context 'trashed' do
      subject{Clip.trashed}
      its(:length){should eq 1}
      it 'should be trashed' do
        subject[0].trash.should be_true
      end
    end
    context 'not_trashed',:not_trashed => true do
      subject{Clip.not_trashed}
      its(:length){should eq 18}
      it 'should be not trashed' do
        subject[0].trash.should be_false
      end
    end
    context 'user',:user => true do
      subject{Clip.user @user}
      its(:length){should eq 19}
    end
    context 'page' do
      subject{Clip.page 2}
      its(:length){should eq 8}
    end
    context 'tag',:tag => true do
      subject{Clip.tag @tag}
      its(:length){should eq 1}
    end
    context 'updated_at',:updated_at => true do
      subject{Clip.updated_at @date}
      its(:length){should eq 1}
    end
  end
  context 'paging' do
    before do
      @user = create(:user)
      create_list(:clip,15,user: @user)
    end
    describe 'first page' do
      subject{Clip.user(@user).page}
      its(:length){should eq 8}
    end
    describe 'second page' do
      subject{Clip.user(@user).page(2)}
      its(:length){should eq 7}
    end
    describe 'third page' do
      subject{Clip.user(@user).page(3)}
      its(:length){should eq 0}
    end
  end
  context 'search',search: true do
    before do
      @user = create(:user)
      create(:search_clip,user: @user)
    end
    subject {Clip.user(@user).search('test').page.to_a}
    its(:length){should eq 1}
  end
end
