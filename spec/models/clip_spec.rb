# -*- coding: utf-8 -*-
require 'spec_helper'

describe Clip do
  context 'attributes' do
    subject{Clip.new}
    its(:title)       {should be_nil}
    its(:type)        {should be_nil}
    its(:image)       {should be_nil}
    its(:description) {should be_nil}
    its(:url)         {should be_nil}
  end
  context 'load og content' do
    before do
      doc = Nokogiri::HTML(open("#{Rails.root}/spec/support/ogp/#{file}"))
      Nokogiri::HTML::Document.stub!(:parse).and_return(doc)
      @clip = Clip.new(:url => url)
      @clip.load
    end
    subject{@clip}
    let(:file){'empty.html'}
    context 'error cases' do
      describe 'url is nil case' do
        let(:url){nil}
        its(:title)   {should be_nil}
      end
      describe 'url is empty string case' do
        let(:url){''}
        its(:title)   {should be_nil}
      end
      context 'illegal url' do
        let(:url){'//example.com/empty.html'}
        its(:title)  {should be_nil}
      end
      describe 'load empty content' do
        let(:url){'http://example.com/empty.html'}
        its(:title)  {should be_nil}
      end
    end
    context 'normal cases' do
      describe 'load content' do
        let(:file){'mine.html'}
        let(:url){'http://example.com/mine.html'}
        its(:title)  {should == 'Fly me to the Juno!'}
        its(:type)  {should == 'blog'}
        its(:image)  {should == 'http://www.st-hatena.com/users/ko/kompiro/user_p.gif?'}
        its(:url)  {should == 'http://d.hatena.ne.jp/kompiro/'}
        its(:description)  {should == 'Planet Eclipseにも参加しています。ソリューションログを軸に書いてます。'}
      end
    end
  end
end
