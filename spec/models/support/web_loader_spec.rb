# -*- coding: utf-8 -*-
require 'spec_helper'
require 'open-uri'
require 'uri'

describe Support::WebLoader do
  context 'load og content' do
    before do
      doc = open("#{Rails.root}/spec/support/ogp/#{file}")

      read = mock('open')
      read.stub(:meta).and_return({'content-type' => 'text/html;'})
      read.stub(:read).and_return(doc.read)
      read.stub(:charset).and_return(charset)
      read.stub(:base_uri).and_return(URI.parse(base_uri))

      @clip = Clip.new(:url => url)
      @loader = Support::WebLoader.new(@clip)
      @loader.stub!(:open).and_return(read)

      @result = @loader.load
    end
    subject{@clip}
    let(:file){'empty.html'}
    let(:charset){'utf-8'}
    context 'error cases' do
      describe 'url is nil case' do
        let(:url)       {nil}
        let(:base_uri)  {'http://example.com'} #dummy
        its(:title)     {should be_nil}
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
        let(:base_uri)  {'http://example.com'} #dummy
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
        let(:base_uri){'//example.com/empty.html'}
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
        let(:base_uri){'http://example.com/empty.html'}
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
        let(:base_uri)     {'http://example.com/error.html'}
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
        let(:base_uri)     {'http://d.hatena.ne.jp/kompiro/'}
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
        let(:base_uri)     {'https://github.com/plataformatec/devise/wiki/OmniAuth%3A-Overview'}
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
        let(:base_uri){'http://example.com/not_ogp.html'}
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
        let(:base_uri)     {'http://togetter.com/li/284806'}
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
        let(:base_uri)     {'http://www.youtube.com/watch?v=I7nKNs6dUJ4'}
        let(:charset)      {'utf-8'}
        it                 {@result.should be_true}
        its(:title)        {should == "TV初「モテキ」漫画家・久保ミツロウが大暴れ!!\n      - YouTube"}
      end
      describe 'load tumblr content' do
        let(:file)         {'tumblr.html'}
        let(:url)          {'http://sinjow.tumblr.com/post/23523733772/mixi-sns-twitter-140'}
        let(:base_uri)     {'http://sinjow.tumblr.com/post/23523733772/mixi-sns-twitter-140'}
        let(:charset)      {'utf-8'}
        it                 {@result.should be_true}
        its(:title)        {should == "散歩男爵Tumblaneur | mixiがコケた教訓って「SNSは余計なお世話をするな」ってことだな。Twitterは140字縛りを崩..."}
      end
      describe 'load atmarkit content' do
        let(:file)         {'atmark.html'}
        let(:url)          {'http://www.atmarkit.co.jp/im/carc/serial/jobjmdl03/jobjmdl03_2.html'}
        let(:base_uri)     {'http://www.atmarkit.co.jp/im/carc/serial/jobjmdl03/jobjmdl03_2.html'}
        let(:charset)      {'iso-8859-1'}
        it                 {@result.should be_true}
        its(:title)        {should == "＠IT：Javaオブジェクトモデリング 第3回"}
      end
      describe 'load slideshare content' do
        let(:file)         {'slideshare.html'}
        let(:url)          {'http://www.slideshare.net/kkd/tddbctdd'}
        let(:base_uri)     {'http://www.slideshare.net/kkd/tddbctdd'}
        let(:charset)      {'utf-8'}
        it                 {@result.should be_true}
        its(:title)        {should == "TDDBCの前にTDDについて知っておいてもらいたい３つのこと"}
      end
      describe 'load unexpected_encode_error content' do
        let(:file)         {'unexpected_encode_error.html'}
        let(:url)          {'http://www.soubunshu.com/?1348807544'}
        let(:base_uri)     {'http://www.soubunshu.com/?1348807544'}
        let(:charset)      {'shift_jis'}
        it                 {@result.should be_true}
        its(:title)        {should == "宋文洲のメルマガの読者広場"}
      end
    end
    context 'recoverable pattern' do
      describe 'http:/ pattern' do
        let(:file)         {'empty.html'}
        let(:url)          {'http:/example.com/'}
        let(:base_uri)     {'http://example.com/'}
        let(:charset)      {'utf-8'}
        it                 {@result.should be_true}
        its(:url)          {should == 'http://example.com/'}
      end
      describe 'https:/ pattern' do
        let(:file)         {'empty.html'}
        let(:url)          {'https:/example.com/'}
        let(:base_uri)     {'https://example.com/'}
        let(:charset)      {'utf-8'}
        it                 {@result.should be_true}
        its(:url)          {should == 'https://example.com/'}
      end
      describe 'google search result' do
        let(:file)         {'empty.html'}
        let(:url)          {'http://www.google.co.jp/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&ved=0CCUQFjAA&url=http%3A%2F%2Fd.hatena.ne.jp%2Fkompiro%2F&ei=ltB2UPeBMIvFmQWz94FY&usg=AFQjCNF-Q8pnBGBdwTQoBd_tdJ1m7cPwoQ&sig2=8iPE-WjJZZsHTVUSX3ryIQ'}
          let(:base_uri)     {'http://d.hatena.ne.jp/kompiro/'} # not effectiveness spec because always uses this uri
          let(:charset)      {'utf-8'}
          it                 {@result.should be_true}
          its(:url)          {should == 'http://d.hatena.ne.jp/kompiro/'}
        end
      end
      context 'overwrite base_uri' do
        describe 'load shorten url' do
          let(:file)         {'empty.html'}
          let(:url)              {'http://shorten.me/kompiro'}
          let(:base_uri)         {'http://d.hatena.ne.jp/kompiro'}
          its(:url)              {should == 'http://d.hatena.ne.jp/kompiro'}
        end
      end
    end
    context 'load image content from url' do
      before do
        read = mock('open')
        read.stub(:meta).and_return(meta)
        read.stub(:base_uri).and_return(URI.parse(url))

        @clip = Clip.new(:url => url)
        @loader = Support::WebLoader.new(@clip)
        @loader.stub!(:open).and_return(read)

        @result = @loader.load
      end
      subject{@clip}
      describe 'load gif image' do
        let(:url)            {'http://www.st-hatena.com/users/ko/kompiro/profile.gif'}
        let(:meta)           {{"date"=>"Sun, 30 Sep 2012 10:26:00 GMT",
          "server"=>"Apache/2.2.3 (CentOS)",
          "etag"=>"\"0059290913\"",
          "cache-control"=>"public, max-age=86400, s-maxage=86400",
          "content-type"=>"image/gif",
          "content-length"=>"2773",
          "age"=>"11046",
          "x-cache"=>"HIT from squid.hatena.ne.jp",
          "x-cache-lookup"=>"HIT from squid.hatena.ne.jp:80",
          "via"=>"1.0 wwwsquid09.hatena.ne.jp:80 (squid/2.7.STABLE6)"}}
        its(:url)            {should == 'http://www.st-hatena.com/users/ko/kompiro/profile.gif'}
        its(:image)          {should == 'http://www.st-hatena.com/users/ko/kompiro/profile.gif'}
        its(:title)          {should == 'profile.gif'}
        its(:description)    {should == nil}
      end
      describe 'load png image' do
        let(:url)            {'http://gigazine.jp/img/2007/10/19/iconica/iconica_preview_m.png'}
        let(:meta)           {{"date"=>"Sun, 30 Sep 2012 10:59:34 GMT",
          "server"=>"Apache/2.2.3 (CentOS)",
          "last-modified"=>"Fri, 19 Oct 2007 02:43:07 GMT",
          "etag"=>"\"372033e-b119-7e9da4c0\"",
          "accept-ranges"=>"bytes",
          "content-length"=>"45337",
          "cache-control"=>"max-age=31536000",
          "expires"=>"Mon, 30 Sep 2013 10:59:34 GMT",
          "connection"=>"close",
          "content-type"=>"image/png"}}
        its(:url)            {should == 'http://gigazine.jp/img/2007/10/19/iconica/iconica_preview_m.png'}
        its(:image)          {should == 'http://gigazine.jp/img/2007/10/19/iconica/iconica_preview_m.png'}
        its(:title)          {should == 'iconica_preview_m.png'}
        its(:description)    {should == nil}
      end
      describe 'load jpg image' do
        let(:url)            {'http://www.toshiba-sol.co.jp/sol/gene/package/kyoiku/images/top/img_index_main.jpg'}
        let(:meta)           {{"date"=>"Sun, 30 Sep 2012 11:04:25 GMT",
          "server"=>"Apache",
          "last-modified"=>"Fri, 03 Sep 2010 07:42:24 GMT",
          "accept-ranges"=>"bytes",
          "content-length"=>"31840",
          "content-type"=>"image/jpeg",
          "set-cookie"=> "citrix_ns_id=PVQd/zL1LeIXWyz7eyAVBCbKyHEA010; Domain=.toshiba-sol.co.jp; Path=/; HttpOnly"}}
        its(:url)            {should == 'http://www.toshiba-sol.co.jp/sol/gene/package/kyoiku/images/top/img_index_main.jpg'}
        its(:image)          {should == 'http://www.toshiba-sol.co.jp/sol/gene/package/kyoiku/images/top/img_index_main.jpg'}
        its(:title)          {should == 'img_index_main.jpg'}
        its(:description)    {should == nil}
      end
    end
    context 'load image content from url and image' do
      before do
        read = mock('open')
        read.stub(:meta).and_return(meta)
        read.stub(:base_uri).and_return(URI.parse(url))

        @clip = Clip.new(:url => url,:image => image)
        @loader = Support::WebLoader.new(@clip)
        @loader.stub!(:open).and_return(read)

        @result = @loader.load
      end
      subject{@clip}
      describe 'load gif image' do
        let(:url)              {'http://d.hatena.ne.jp/kompiro'}
        let(:image)            {'http://www.st-hatena.com/users/ko/kompiro/profile.gif'}
        let(:meta)           {{"date"=>"Sun, 30 Sep 2012 10:26:00 GMT",
          "server"=>"Apache/2.2.3 (CentOS)",
          "etag"=>"\"0059290913\"",
          "cache-control"=>"public, max-age=86400, s-maxage=86400",
          "content-type"=>"image/gif",
          "content-length"=>"2773",
          "age"=>"11046",
          "x-cache"=>"HIT from squid.hatena.ne.jp",
          "x-cache-lookup"=>"HIT from squid.hatena.ne.jp:80",
          "via"=>"1.0 wwwsquid09.hatena.ne.jp:80 (squid/2.7.STABLE6)"}}
        its(:url)            {should == 'http://d.hatena.ne.jp/kompiro'}
        its(:image)          {should == 'http://www.st-hatena.com/users/ko/kompiro/profile.gif'}
        its(:title)          {should == 'profile.gif'}
        its(:description)    {should == 'clip from http://d.hatena.ne.jp/kompiro'}
      end
      describe 'load png image' do
        let(:url)            {'http://gigazine.jp/img/2007/10/19/iconica/'}
        let(:image)            {'http://gigazine.jp/img/2007/10/19/iconica/iconica_preview_m.png'}
        let(:meta)           {{"date"=>"Sun, 30 Sep 2012 10:59:34 GMT",
          "server"=>"Apache/2.2.3 (CentOS)",
          "last-modified"=>"Fri, 19 Oct 2007 02:43:07 GMT",
          "etag"=>"\"372033e-b119-7e9da4c0\"",
          "accept-ranges"=>"bytes",
          "content-length"=>"45337",
          "cache-control"=>"max-age=31536000",
          "expires"=>"Mon, 30 Sep 2013 10:59:34 GMT",
          "connection"=>"close",
          "content-type"=>"image/png"}}
        its(:url)            {should == 'http://gigazine.jp/img/2007/10/19/iconica/'}
        its(:image)          {should == 'http://gigazine.jp/img/2007/10/19/iconica/iconica_preview_m.png'}
        its(:title)          {should == 'iconica_preview_m.png'}
        its(:description)    {should == 'clip from http://gigazine.jp/img/2007/10/19/iconica/'}
      end
      describe 'load jpg image' do
        let(:url)            {'http://www.toshiba-sol.co.jp/sol/gene/package/kyoiku/'}
        let(:image)          {'http://www.toshiba-sol.co.jp/sol/gene/package/kyoiku/images/top/img_index_main.jpg'}
        let(:meta)           {{"date"=>"Sun, 30 Sep 2012 11:04:25 GMT",
          "server"=>"Apache",
          "last-modified"=>"Fri, 03 Sep 2010 07:42:24 GMT",
          "accept-ranges"=>"bytes",
          "content-length"=>"31840",
          "content-type"=>"image/jpeg",
          "set-cookie"=> "citrix_ns_id=PVQd/zL1LeIXWyz7eyAVBCbKyHEA010; Domain=.toshiba-sol.co.jp; Path=/; HttpOnly"}}
        its(:url)            {should == 'http://www.toshiba-sol.co.jp/sol/gene/package/kyoiku/'}
        its(:image)          {should == 'http://www.toshiba-sol.co.jp/sol/gene/package/kyoiku/images/top/img_index_main.jpg'}
        its(:title)          {should == 'img_index_main.jpg'}
        its(:description)    {should == 'clip from http://www.toshiba-sol.co.jp/sol/gene/package/kyoiku/'}
      end
    end
    context 'OpenURI::HTTPError is occurred' do
      before do
        @clip = Clip.new(:url => 'http://example.com/')
        @loader = Support::WebLoader.new(@clip)
        @loader.stub!(:open).and_raise OpenURI::HTTPError.new message,nil
        @result = @loader.load
      end
      describe '404 Not Found' do
        let(:message)      {'404 Not Found'}
        it                   {@result.should be_false}
        it 'has one error' do
          @clip.errors.size.should be 1
        end
        it 'has url error' do
          @clip.errors[:url][0].should == "access 'http://example.com/' error : 404 Not Found"
        end
      end
    end
end
