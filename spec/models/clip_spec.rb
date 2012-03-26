# -*- coding: utf-8 -*-
require 'spec_helper'

describe Clip do
  fixtures :clips
  context 'attributes' do
    subject{Clip.new}
    its(:title)       {should be_nil}
    its(:og_type)        {should be_nil}
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
        its(:title)  {should == ''}
      end
    end
    context 'normal cases' do
      describe 'load ogp content' do
        let(:file){'mine.html'}
        let(:url){'http://example.com/mine.html'}
        its(:title)        {should == 'Fly me to the Juno!'}
        its(:og_type)      {should == 'blog'}
        its(:image)        {should == 'http://www.st-hatena.com/users/ko/kompiro/user_p.gif?'}
        its(:url)          {should == 'http://d.hatena.ne.jp/kompiro/'}
        its(:description)  {should == 'Planet Eclipseにも参加しています。ソリューションログを軸に書いてます。'}
      end
      describe 'load not ogp content' do
        let(:file){'not_ogp.html'}
        let(:url){'http://example.com/not_ogp.html'}
        its(:title)        {should == 'ゆるキャラ「まんべくん」哀れな末路 - ソーシャルメディア炎上事件簿：ITpro'}
        its(:og_type)      {should be_nil}
        its(:image)        {should == 'http://itpro.nikkeibp.co.jp/article/COLUMN/20111111/374386/top.jpg'}
        its(:url)          {should == 'http://example.com/not_ogp.html'}
        its(:description)  {should == '　キャラクターの面白さがメディアでもたびたび紹介されるようになるにつれ、まんべくんは変節していった。それはもはや自由奔放という枠を超え、他者をおとしめることもいとわない、過激な毒舌へとエスカレートしていった。'}
      end
    end
  end
  context 'paging' do
    describe 'first page' do
      subject{Clip.page}
      its(:length){should eq 8}
    end
    describe 'second page' do
      subject{Clip.page(2)}
      its(:length){should eq 5}
    end
    describe 'third page' do
      subject{Clip.page(3)}
      its(:length){should eq 0}
    end
  end
end
