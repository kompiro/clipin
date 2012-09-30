require 'spec_helper'
require 'open-uri'

describe Api::V1::ClipsController do

  let(:token) { stub :accessible? => true ,:resource_owner_id => 1}
  before do
    @user = create(:user)
    User.current = @user
    controller.stub(:doorkeeper_token) { token }
  end

  before :each do

    doc = open("#{Rails.root}/spec/support/ogp/example_com.html")

    read = mock('open')
    read.stub(:meta).and_return({'content-type'=>'text/html'})
    read.stub(:read).and_return(doc.read)
    read.stub(:charset).and_return('utf-8')

    Support::WebLoader.any_instance.stub(:open).and_return(read)

  end

  def valid_attributes
    {url:'http://example.com/'}
  end

  def valid_session
    {user_id:1}
  end

  describe "GET index" do
    it "assigns first clips as @clips" do
      clip = Clip.create! valid_attributes
      get :index, {}, valid_session
      assigns(:clips).should eq(Clip.page)
    end
    it "assigns second clips as @clips" do
      clip = Clip.create! valid_attributes
      get :index, {:page => 2}, valid_session
      assigns(:clips).should eq(Clip.page(2))
    end
  end

  describe "GET show" do
    it "assigns the requested clip as @clip" do
      clip = Clip.create! valid_attributes
      get :show, {:id => clip.id}, valid_session
      assigns(:clip).should eq(clip)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Clip" do
        expect {
          post :create, {:clip => valid_attributes}, valid_session
        }.to change(Clip, :count).by(1)
      end

      it "assigns a newly created clip as @clip" do
        post :create, {:clip => valid_attributes}, valid_session
        assigns(:clip).should be_a(Clip)
        assigns(:clip).should be_persisted
      end

      it "redirects to the created clip" do
        post :create, {:clip => valid_attributes}, valid_session
        response.code.should eq '201'
      end
      describe "already created params" do
        before do
          @clip = Clip.create! valid_attributes
        end

        it "doesn't create newer one" do
          expect {
            post :create, {:clip => valid_attributes}, valid_session
          }.to change(Clip, :count).by(0)
        end

        it "updates clip_count" do
            post :create, {:clip => valid_attributes}, valid_session
            Clip.find(@clip.id).clip_count.should eq(2)
        end

        it "updates updated_by" do
            post :create, {:clip => valid_attributes}, valid_session
            Clip.find(@clip.id).updated_at.should_not eq(@clip.updated_at)
        end
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
        parsed = JSON.parse(response.body)
        parsed['url'].length.should eq 1
        parsed['url'][0].should eq "url can't be empty"
      end
    end
  end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested clip" do
          clip = Clip.create! valid_attributes
          # Assuming there are no other clips in the database, this
          # specifies that the Clip created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Clip.any_instance.should_receive(:update_attributes).with({'these' => 'params','tags' => []})
          put :update, {:id => clip.to_param, :clip => {'these' => 'params'}}, valid_session
        end

        it "assigns the requested clip as @clip" do
          clip = Clip.create! valid_attributes
          put :update, {:id => clip.to_param, :clip => valid_attributes}, valid_session
          assigns(:clip).should eq(clip)
        end

        it "returns 200" do
          clip = Clip.create! valid_attributes
          put :update, {:id => clip.to_param, :clip => valid_attributes}, valid_session
          response.code.should eq '200'
        end
      end

      describe "with invalid params" do
        it "assigns the clip as @clip" do
          clip = Clip.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Clip.any_instance.stub(:save).and_return(false)
          put :update, {:id => clip.to_param, :clip => {}}, valid_session
          assigns(:clip).should eq(clip)
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested clip" do
        clip = Clip.create! valid_attributes
        expect {
          delete :destroy, {:id => clip.to_param}, valid_session
        }.to change(Clip, :count).by(-1)
      end

      it "returns 200" do
        clip = Clip.create! valid_attributes
        delete :destroy, {:id => clip.to_param}, valid_session
          response.code.should eq '200'
    end
  end

end
