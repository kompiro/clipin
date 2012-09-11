# -*- coding: utf-8 -*-
require 'spec_helper'
require 'open-uri'

describe WebLoader do
  context 'load og content' do
    before do
      doc = open("#{Rails.root}/spec/support/ogp/#{file}")

      read = mock('open')
      read.stub(:read).and_return(doc.read)
      read.stub(:charset).and_return(charset)

      @clip = Clip.new(:url => url)
      @loader = WebLoader.new(@clip)
      @loader.stub!(:open).and_return(read)

      @result = @loader.load
    end
    subject{@clip}
    let(:file){'empty.html'}
    let(:charset){'utf-8'}
    context 'error cases' do
      describe 'url is nil case' do
        let(:url)     {nil}
        its(:title)   {should be_nil}
        context 'errors' do
          it 'has one error' do
            @clip.errors.size.should be 1
          end
          it 'has url error' do
            @clip.errors[:url][0].should == "url can't be empty"
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
            @clip.errors[:url][0].should == "url can't be empty"
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
            @clip.errors[:url][0].should == "url should start with 'http:' or 'https:'"
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
        let(:charset)      {'utf-8'}
        it                 {@result.should be_true}
        its(:title)        {should == 'Backbone.js'}
        its(:url)          {should == 'http://example.com/error.html'}
      end
    end
    context 'normal cases' do
      describe 'load ogp content' do
        let(:file)         {'mine.html'}
        let(:url)          {'http://d.hatena.ne.jp/kompiro/'}
        let(:charset)      {'euc-jp'}
        it                 {@result.should be_true}
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
        let(:charset)      {'utf-8'}
        it                 {@result.should be_true}
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
        let(:charset)      {'euc-jp'}
        it                 {@result.should be_true}
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
        let(:file)         {'togetter.html'}
        let(:url)          {'http://togetter.com/li/284806'}
        let(:charset)      {'utf-8'}
        it                 {@result.should be_true}
        its(:title)        {should == '夏場の電力ピーク時の数時間、製造業は節電のために稼働を止められるのか？現場の人に聞いてみた。 - Togetter'}
        its(:og_type)      {should == 'article'}
        its(:image)        {should == 'http://api.twitter.com/1/users/profile_image/Polaris_sky.json?size=bigger'}
        its(:url)          {should == 'http://togetter.com/li/284806'}
        its(:description)  {should == '日本のGDPの約2割を稼ぎ、約1000万人の雇用を擁する製造業。製造業はその性質上大量の電力を消費します（全体の4割の電力を製造業が使用）。原発が停止した現在、一部の反原発派な方々から「夏場の数時間の為に原発を動かす必要がない」とか「その数時間だけ節電すれば原発は要らない」という声が聞こえてきます。が、製造業にとってその数時間は大事なんじゃないか？と現場の人にきいてみたら貴重なご意見をいただきました。貴重なご意見本当に有難う御座いました。m(_ _)m'}
      end
      describe 'load youtube content' do
        let(:file)         {'youtube.html'}
        let(:url)          {'http://www.youtube.com/watch?v=I7nKNs6dUJ4'}
        let(:charset)      {'utf-8'}
        it                 {@result.should be_true}
        its(:title)        {should == "TV初「モテキ」漫画家・久保ミツロウが大暴れ!!\n      - YouTube"}
      end
      describe 'load tumblr content' do
        let(:file)         {'tumblr.html'}
        let(:url)          {'http://sinjow.tumblr.com/post/23523733772/mixi-sns-twitter-140'}
        let(:charset)      {'utf-8'}
        it                 {@result.should be_true}
        its(:title)        {should == "散歩男爵Tumblaneur | mixiがコケた教訓って「SNSは余計なお世話をするな」ってことだな。Twitterは140字縛りを崩..."}
      end
      describe 'load atmarkit content' do
        let(:file)         {'atmark.html'}
        let(:url)          {'http://www.atmarkit.co.jp/im/carc/serial/jobjmdl03/jobjmdl03_2.html'}
        let(:charset)      {'iso-8859-1'}
        it                 {@result.should be_true}
        its(:title)        {should == "＠IT：Javaオブジェクトモデリング 第3回"}
      end
      describe 'load slideshare content' do
        let(:file)         {'slideshare.html'}
        let(:url)          {'http://www.slideshare.net/kkd/tddbctdd'}
        let(:charset)      {'utf-8'}
        it                 {@result.should be_true}
        its(:title)        {should == "TDDBCの前にTDDについて知っておいてもらいたい３つのこと"}
      end
    end
    context 'recoverable pattern' do
      describe 'http:/ pattern' do
        let(:file)         {'empty.html'}
        let(:url)          {'http:/example.com/'}
        let(:charset)      {'utf-8'}
        it                 {@result.should be_true}
        its(:url)          {should == 'http://example.com/'}
      end
      describe 'https:/ pattern' do
        let(:file)         {'empty.html'}
        let(:url)          {'https:/example.com/'}
        let(:charset)      {'utf-8'}
        it                 {@result.should be_true}
        its(:url)          {should == 'https://example.com/'}
      end
    end
  end
end
