require 'spec_helper'
require 'open-uri'

describe ClipsController do

  before do
    @user = create(:user)
  end

  before :each do

    doc = open("#{Rails.root}/spec/support/ogp/example_com.html")

    read = double('open')
    read.stub(:read).and_return(doc.read)
    read.stub(:meta).and_return({'content-type' => 'text/html'})
    read.stub(:charset).and_return('utf-8')
    read.stub(:base_uri).and_return(URI.parse("http://example.com/"))
    read.stub(:content_encoding).and_return([])

    Support::WebLoader.any_instance.stub(:open).and_return(read)

  end

  def valid_attributes
    {url:'http://example.com/'}
  end

  def valid_https_attributes
    {url:'https://example.com/'}
  end

  def recoverable_http_attributes
    {url:'http:/example.com/'}
  end

  def recoverable_https_attributes
    {url:'https:/example.com/'}
  end

  def valid_session
    {user_id:1}
  end

  describe "GET index" do
    context 'only user' do
      before do
        create(:clip)
      end
      it "assigns first clips as @clips",:not_trashed => true do
        get :index, {}, valid_session
        expect(assigns(:clips).to_a).to eq(Clip.user(@user).not_trashed.page.to_a)
        expect(assigns(:tags).to_a).to eq(Tag.all.to_a)
        expect(flash[:notice]).to be_nil
      end
      it "assigns second clips as @clips" do
        get :index, {:page => 2}, valid_session
        expect(assigns(:clips).to_a).to eq(Clip.user(@user).not_trashed.page(2).to_a)
        expect(flash[:notice]).to be_nil
      end
    end
    context 'index by trash',:trash => true do
      before do
        create_list(:trashed_clip,20,user: @user)
      end
      it "assigns trashed clips as @clips" do
        get :index, {:trashed => true}, valid_session
        expect(assigns(:clips).to_a).to eq(Clip.user(@user).trashed.page.to_a)
        expect(flash[:notice]).to be_nil
      end
      it "assigns trashed clips at page 2as @clips" do
        get :index, {:trashed => true,:page => 2}, valid_session
        assigns(:clips).to_a.should eq(Clip.user(@user).trashed.page(2).to_a)
        flash[:notice].should be_nil
      end
    end
    context 'index by pin' do
      before do
        create_list(:pinned_clip,20,user: @user)
      end
      it "assigns pinned clips as @clips" do
        get :index, {:pinned => true}, valid_session
        assigns(:clips).to_a.should eq(Clip.user(@user).not_trashed.pinned.page.to_a)
        flash[:notice].should be_nil
      end
    end
    context 'index by tag',:tag => true do
      before do
        clips = create_list(:pinned_clip,20,user: @user)
        @tag = create(:tag)
        clips.each do |clip|
          create(:tagging,tag: @tag,clip: clip)
        end
      end
      it "assigns tagged clips as @clips" do
        get :index, {:tag => @tag.name}, valid_session
        assigns(:clips).to_a.should eq(Clip.user(@user).not_trashed.tag(@tag).page.to_a)
        flash[:notice].should be_nil
      end
    end
    context 'index by updated_at',:date => true do
      before do
        @date = Time.parse('2012/11/2')
        create_list(:clip,20,user: @user,created_at: @date, updated_at: @date)
      end
      it 'assigns updated_at clips as @clips' do
        get :index, {:date => @date}, valid_session
        assigns(:clips).to_a.should eq(Clip.user(@user).not_trashed.updated_at(@date).page.to_a)
        flash[:notice].should be_nil
      end
    end
  end

  describe "GET search" do
    before do
      create_list(:clip,20,user: @user)
      create_list(:search_clip,20,user: @user)
    end
    it "assigns specified query to search clips" do
      get :search, {q: 'test'}, valid_session
      assigns(:clips).to_a.should eq(Clip.user(@user).search('test').page.to_a)
      assigns(:tags).to_a.should eq(Tag.all.to_a)
      flash[:notice].should be_nil
    end
    it "assigns specified query and page to search clips" do
      get :search, {q: 'test', page: 2}, valid_session
      assigns(:clips).to_a.should eq(Clip.user(@user).search('test').page(2).to_a)
      assigns(:tags).to_a.should eq(Tag.all.to_a)
    end
  end

  describe "GET show" do
    before do
      @clip = Clip.create! valid_attributes
      @clip.user = @user
      @clip.save
    end
    it "assigns the requested clip as @clip" do
      get :show, {:id => @clip.id}, valid_session
      assigns(:clip).should eq(@clip)
    end
  end

  describe "GET new" do
    it "assigns a new clip as @clip" do
      get :new, {}, valid_session
      assigns(:clip).should be_a_new(Clip)
    end
  end

  describe "GET edit" do
    before do
      @clip = Clip.create! valid_attributes
      @clip.user = @user
      @clip.save
    end
    it "assigns the requested clip as @clip" do
      get :edit, {:id => @clip.to_param}, valid_session
      assigns(:clip).should eq(@clip)
    end
  end

  describe "GET create_by_bookmarklet",:bookmarklet => true do
    shared_examples_for 'acceptable attributes for create_by_bookmarklet' do
      it "creates a new Clip" do
        expect {
          get :create_by_bookmarklet, attributes, valid_session
        }.to change(Clip, :count).by(1)
      end

      it "assigns a newly created clip as @clip" do
        get :create_by_bookmarklet, attributes, valid_session
        assigns(:clip).should be_a(Clip)
        assigns(:clip).should be_persisted
      end

      it "redirects to the created clip" do
        get :create_by_bookmarklet, attributes, valid_session
        response.should be_success
      end
      describe "already created params" do
        before do
          @clip = Clip.create! init_attributes
          @clip.user = @user
          @clip.save
        end
        it "doesn't create newer one" do
          expect {
            get :create_by_bookmarklet, attributes, valid_session
          }.to change(Clip, :count).by(0)
        end

        it "updates clip_count",:target => true do
          get :create_by_bookmarklet, attributes, valid_session
          Clip.find(@clip.id).clip_count.should eq(2)
        end
        it "updates updated_by" do
          get :create_by_bookmarklet, attributes, valid_session
          Clip.find(@clip.id).updated_at.should_not eq(@clip.updated_at)
        end
      end
    end
    describe "with valid params" do
      it_should_behave_like 'acceptable attributes for create_by_bookmarklet' do
        let(:init_attributes){valid_attributes}
        let(:attributes){valid_attributes}
      end
    end
    describe "with recoverable http attributes" do
      it_should_behave_like 'acceptable attributes for create_by_bookmarklet' do
        let(:init_attributes){valid_attributes}
        let(:attributes){recoverable_http_attributes}
      end
    end
    describe "with recoverable https attributes" do
      it_should_behave_like 'acceptable attributes for create_by_bookmarklet' do
        let(:init_attributes){valid_https_attributes}
        let(:attributes){recoverable_https_attributes}
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved clip as @clip" do
        # Trigger the behavior that occurs when invalid params are submitted
        Clip.any_instance.stub(:save).and_return(false)
        get :create_by_bookmarklet, {:url => ''}, valid_session
        assigns(:clip).should be_a_new(Clip)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Clip.any_instance.stub(:save).and_return(false)
        get :create_by_bookmarklet, {:url => ''}, valid_session
        response.should be_success
      end
    end
  end

  describe "POST create" do
    shared_examples_for 'acceptable attributes' do
      it "creates a new Clip" do
        expect {
          post :create, {:clip => attributes}, valid_session
        }.to change(Clip, :count).by(1)
      end

      it "assigns a newly created clip as @clip" do
        post :create, {:clip => attributes}, valid_session
        assigns(:clip).should be_a(Clip)
        assigns(:clip).should be_persisted
      end

      it "redirects to the created clip" do
        post :create, {:clip => attributes}, valid_session
        response.should redirect_to(clips_path)
      end
      describe "already created params" do
        before do
          @clip = Clip.create! init_attributes
          @clip.user = @user
          @clip.save
        end
        it "doesn't create newer one" do
          expect {
            post :create, {:clip => attributes}, valid_session
          }.to change(Clip, :count).by(0)
        end

        it "updates clip_count" do
          post :create, {:clip => attributes}, valid_session
          Clip.find(@clip.id).clip_count.should eq(2)
        end

        it "updates updated_by" do
          post :create, {:clip => attributes}, valid_session
          Clip.find(@clip.id).updated_at.should_not eq(@clip.updated_at)
        end
      end
    end
    describe "with valid params" do
      it_should_behave_like 'acceptable attributes' do
        let(:init_attributes){valid_attributes}
        let(:attributes){valid_attributes}
      end
    end
    describe "with recoverable http attributes" do
      it_should_behave_like 'acceptable attributes' do
        let(:init_attributes){valid_attributes}
        let(:attributes){recoverable_http_attributes}
      end
    end
    describe "with recoverable https attributes" do
      it_should_behave_like 'acceptable attributes' do
        let(:init_attributes){valid_https_attributes}
        let(:attributes){recoverable_https_attributes}
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved clip as @clip" do
        # Trigger the behavior that occurs when invalid params are submitted
        Clip.any_instance.stub(:save).and_return(false)
        post :create, {:clip => {}}, valid_session
        assigns(:clip).should be_a_new(Clip)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Clip.any_instance.stub(:save).and_return(false)
        post :create, {:clip => {}}, valid_session
        response.should redirect_to(clips_path)
      end
    end
  end

  describe "PUT update" do
    before do
      @clip = Clip.create! valid_attributes
      @clip.user = @user
      @clip.save
    end
    describe "with valid params" do
      it "updates the requested clip" do
        Clip.any_instance.should_receive(:update).with({})
        put :update, {:id => @clip.to_param, :clip => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested clip as @clip" do
        put :update, {:id => @clip.to_param, :clip => valid_attributes}, valid_session
        assigns(:clip).should eq(@clip)
      end

      it "redirects to the clip" do
        put :update, {:id => @clip.to_param, :clip => valid_attributes}, valid_session
        response.should redirect_to(@clip)
      end
    end

    describe "with invalid params" do
      it "assigns the clip as @clip" do
        # Trigger the behavior that occurs when invalid params are submitted
        Clip.any_instance.stub(:save).and_return(false)
        put :update, {:id => @clip.to_param, :clip => {}}, valid_session
        assigns(:clip).should eq(@clip)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Clip.any_instance.stub(:save).and_return(false)
        put :update, {:id => @clip.to_param, :clip => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @clip = Clip.create! valid_attributes
      @clip.user = @user
      @clip.save
    end
    it "destroys the requested clip" do
      expect {
        delete :destroy, {:id => @clip.to_param}, valid_session
      }.to change(Clip, :count).by(-1)
    end

    it "redirects to the clips list" do
      delete :destroy, {:id => @clip.to_param}, valid_session
      response.should redirect_to(clips_url)
    end
  end
end
