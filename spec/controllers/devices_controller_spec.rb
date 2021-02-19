require 'rails_helper'

RSpec.describe Api::DevicesController, type: :request do
  let(:valid_device) do
    {
      device: {
        carrier: "Verizon",
        phone_number: "+12345556789"
      }
    }
  end

  let(:invalid_device) do
    {
      device: {
        carrier: "Verizon",
        phone_number: "asodfijawon"
      }
    }
  end

  describe "post /api/register" do 
    it "creates a new device" do
      post '/api/register', params: valid_device
      expect(response).to have_http_status(201)
    end

    it "responds with the device id" do
      post '/api/register', params: valid_device
      expect(JSON.parse(response.body)).to have_key("id")
      expect(JSON.parse(response.body)["id"]).to_not be_empty
    end

    it "requires a phone number in a format compatible with phonelib" do
      post '/api/register', params: invalid_device
      expect(response).to have_http_status(500)
    end

    it "responds with an error message when invalid" do
      post '/api/register', params: invalid_device
      expect(JSON.parse(response.body)).to have_key("error")
      expect(JSON.parse(response.body)["error"]).to eq("failed to register device")
    end

  end
  
  describe "post /api/alive" do
    let(:valid_device) do 
      Device.create(carrier: "Verizon", phone_number: "+12345556789")
    end

    let(:disabled_device) do
      Device.create(carrier: "Verizon", phone_number: "+12345556789", disabled_at: DateTime.now)
    end

    it "creates a new heartbeat" do
      post '/api/alive', params: { device_id: valid_device.id }
      expect(response).to have_http_status(201)
    end

    it "responds with an empty object" do
      post '/api/alive', params: { device_id: valid_device.id }
      expect(JSON.parse(response.body)).to be_empty
    end

    
    it "doesn't work if disabled_at is not nil" do
      post '/api/alive', params: { device_id: disabled_device.id }
      expect(response).to have_http_status(500)
    end

    it "responds with an error message if the device id is invalid" do
      post '/api/alive', params: { device_id: 'alsdkfjaowin' }
      expect(JSON.parse(response.body)).to have_key("error")
      expect(JSON.parse(response.body)["error"]).to eq("device not found")
    end
  end  
end