require 'rails_helper'

RSpec.describe Api::DevicesController, type: :request do
  let(:device) do
    {
      device: {
        carrier: "Verizon",
        phone_number: "+12345556789",
        disabled_at: nil
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
      puts JSON.parse(response)
      # expect(response.to )
    end
  end
end