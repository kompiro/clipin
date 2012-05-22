# -*- coding: utf-8 -*-
require 'spec_helper'

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
  context 'load og content' do
    before do
      doc = Nokogiri::HTML(open("#{Rails.root}/spec/support/ogp/#{file}"))
      Nokogiri::HTML::Document.stub!(:parse).and_return(doc)
      @clip = Clip.new(:url => url)
      @result = @clip.load
    end
    subject{@clip}
    let(:file){'empty.html'}
    context 'error cases' do
      describe 'url is nil case' do
        let(:url)     {nil}
        its(:title)   {should be_nil}
        context 'errors' do
          subject{@clip.errors}
          it 'has one error' do
            subject.size.should be 1
          end
          it 'has url error' do
            @clip.errors[:url][0].should == "can't be blank"
          end
        end
      end
      describe 'url is empty string case' do
        let(:url){''}
        it {@result.should be_false}
        its(:title)   {should be_nil}
        context 'errors' do
          subject{@clip.errors}
          it 'has one error' do
            subject.size.should be 1
          end
          it 'has url error' do
            @clip.errors[:url][0].should == "can't be blank"
          end
        end
      end
      context 'illegal url' do
        let(:url){'//example.com/empty.html'}
        it {@result.should be_false}
        its(:title)  {should be_nil}
        context 'errors' do
          subject{@clip.errors}
          it 'has one error' do
            subject.size.should be 1
          end
          it 'has url error' do
            @clip.errors[:url][0].should == "should start with 'http:' or 'https:'"
          end
        end
      end
      describe 'load empty content' do
        let(:url){'http://example.com/empty.html'}
        it {@result.should be_true}
        its(:title)  {should == ''}
        context 'errors' do
          subject{@clip.errors}
          it 'has no errors' do
            subject.size.should be 0
          end
        end
      end
    end
    context 'illegal cases' do
      describe 'load ogp content' do
        let(:file)         {'error.html'}
        let(:url)          {'http://example.com/error.html'}
        it {@result.should be_true}
        its(:title)        {should == 'Backbone.js'}
        its(:url)          {should == 'http://example.com/error.html'}
      end
    end
    context 'normal cases' do
      describe 'load ogp content' do
        let(:file)         {'mine.html'}
        let(:url)          {'http://d.hatena.ne.jp/kompiro/'}
        it {@result.should be_true}
        its(:title)        {should == 'Fly me to the Juno!'}
        its(:og_type)      {should == 'blog'}
        its(:image)        {should == 'http://www.st-hatena.com/users/ko/kompiro/user_p.gif?'}
        its(:url)          {should == 'http://d.hatena.ne.jp/kompiro/'}
        its(:description)  {should == 'Planet Eclipseにも参加しています。ソリューションログを軸に書いてます。'}
        context 'should add by og_type' do
          before do
            subject.tagging
          end
          it{subject.tags.size().should eq 1}
          it{subject.tags[0].name.should eq 'blog'}
        end
      end
      describe 'different url' do
        let(:file)         {'github.html'}
        let(:url)          {'https://github.com/plataformatec/devise/wiki/OmniAuth%3A-Overview'}
        it {@result.should be_true}
        its(:title)        {should == 'OmniAuth: Overview · plataformatec/devise Wiki'}
        its(:og_type)      {should == 'githubog:gitrepository'}
        its(:image)        {should == 'https://a248.e.akamai.net/assets.github.com/images/gravatars/gravatar-140.png?1329275856'}
        its(:url)          {should == 'https://github.com/plataformatec/devise/wiki/OmniAuth%3A-Overview'}
        its(:description)  {should == 'devise - Flexible authentication solution for Rails with Warden.'}
        context 'do not save same name tag' do
          before do
            subject.tagging
          end
          it{Tag.where(:name => 'githubog:gitrepository').size().should eq 1}
        end
      end
      describe 'load not ogp content' do
        let(:file){'not_ogp.html'}
        let(:url){'http://example.com/not_ogp.html'}
        it {@result.should be_true}
        its(:title)        {should == 'ゆるキャラ「まんべくん」哀れな末路 - ソーシャルメディア炎上事件簿：ITpro'}
        its(:og_type)      {should be_nil}
        its(:image)        {should == 'http://itpro.nikkeibp.co.jp/article/COLUMN/20111111/374386/top.jpg'}
        its(:url)          {should == 'http://example.com/not_ogp.html'}
        its(:description)  {should == '　キャラクターの面白さがメディアでもたびたび紹介されるようになるにつれ、まんべくんは変節していった。それはもはや自由奔放という枠を超え、他者をおとしめることもいとわない、過激な毒舌へとエスカレートしていった。'}
        context 'does not have og_type' do
          before do
            subject.tagging
          end
          it{subject.tags.size().should eq 0}
        end
      end
      describe 'load toggeter content' do
        let(:file){'togetter.html'}
        let(:url){'http://togetter.com/li/284806'}
        it {@result.should be_true}
        its(:title)        {should == '夏場の電力ピーク時の数時間、製造業は節電のために稼働を止められるのか？現場の人に聞いてみた。 - Togetter'}
        its(:og_type)      {should == 'article'}
        its(:image)        {should == 'http://api.twitter.com/1/users/profile_image/Polaris_sky.json?size=bigger'}
        its(:url)          {should == 'http://togetter.com/li/284806'}
        its(:description)  {should == '日本のGDPの約2割を稼ぎ、約1000万人の雇用を擁する製造業。製造業はその性質上大量の電力を消費します（全体の4割の電力を製造業が使用）。原発が停止した現在、一部の反原発派な方々から「夏場の数時間の為に原発を動かす必要がない」とか「その数時間だけ節電すれば原発は要らない」という声が聞こえてきます。が、製造業にとってその数時間は大事なんじゃないか？と現場の人にきいてみたら貴重なご意見をいただきました。貴重なご意見本当に有難う御座いました。m(_ _)m'}
      end
      describe 'load youtube content' do
        let(:file){'youtube.html'}
        let(:url){'http://www.youtube.com/watch?v=I7nKNs6dUJ4'}
        it {@result.should be_true}
        its(:title)        {should == 'TV初「モテキ」漫画家・久保ミツロウが大暴れ!!'}
      end
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
