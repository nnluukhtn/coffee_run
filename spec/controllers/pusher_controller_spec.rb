require 'rails_helper'

RSpec.describe PusherController, :type => :controller do

  describe "GET webhook" do
    it "returns http success" do
      get :webhook
      expect(response).to be_success
    end
  end

end
