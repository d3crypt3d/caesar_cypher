require 'rails_helper'

RSpec.describe CryptController, :type => :controller do

  describe "GET encrypt" do
    it "returns http success" do
      get :encrypt
      expect(response).to be_success
    end
  end

  describe "GET decrypt" do
    it "returns http success" do
      get :decrypt
      expect(response).to be_success
    end
  end

end
