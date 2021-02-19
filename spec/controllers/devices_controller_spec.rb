require 'rails_helper'

RSpec.describe Api::DevicesController, type: :request do
  let(:device) do
    {
      device: {
        carrier: "Verizon",
        phone_number: "+12345556789"
      }
    }
  end

  describe "post /api/register" do 
    it "creates a new device" do
      post '/api/register', params: device
      expect(response).to have_http_status(201)
    end

    it "responds with the device id" do
      post '/api/register', params: device
      expect(JSON.parse(response.body)).to have_key("id")
      expect(JSON.parse(response.body)["id"]).to_not be_empty
    end

    # it "doesn't work if disabled_at is not nil" do
    #   disabled_device = {
    #     device: {
    #       carrier: "Verizon",
    #       phone_number: "+12345556789",
    #       disabled_at: DateTime.now
    #     }
    #   }
      
    #   post '/api/register', params: disabled_device
    #   expect(response).to have_http_status(500)
    # end
  end

  
end