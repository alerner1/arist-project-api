require 'rails_helper'

RSpec.describe Api::DevicesController, type: :controller do
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
      # test counts how many devices there are
      # then creates a new one
      # then checks that the number of devices has increased by 1
      
      initial_devices = Device.all.length
      request.headers["Content-Type"] = "application/json"
      post :register, params: valid_device
      updated_devices = Device.all.length

      expect(updated_devices).to eq(initial_devices + 1)
    end

    it "responds with an http status of 'created'" do
      request.headers["Content-Type"] = "application/json"
      post :register, params: valid_device

      expect(response).to have_http_status(201)
    end

    it "responds with the device id" do
      # test creates a new device via post request to '/api/register'
      # then checks that the most recent device in the db has the same id as in the response
      
      request.headers["Content-Type"] = "application/json"
      post :register, params: valid_device
      saved_device = Device.last

      expect(JSON.parse(response.body)).to have_key("id")
      expect(JSON.parse(response.body)["id"]).to eq(saved_device.id)
    end

    it "requires a phone number in a format compatible with phonelib" do
      request.headers["Content-Type"] = "application/json"
      post :register, params: invalid_device

      expect(response).to have_http_status(500)
    end

    it "responds with an error message when invalid" do
      request.headers["Content-Type"] = "application/json"
      post :register, params: invalid_device

      expect(JSON.parse(response.body)).to have_key("error")
      expect(JSON.parse(response.body)["error"]).to eq("failed to register device")
    end

    it "responds with an http status of 500 when invalid" do
      request.headers["Content-Type"] = "application/json"
      post :register, params: invalid_device

      expect(response).to have_http_status(500)
    end

    it "responds with an error message if the 'Content-Type' header is not 'application/json'" do
      request.headers["Content-Type"] = "multipart/form-data"

      post :register, params: valid_device
      
      expect(JSON.parse(response.body)).to have_key("error")
      expect(JSON.parse(response.body)["error"]).to eq("incorrect request headers")
    end

    it "responds with an http status of 500 if the 'Content-Type' header is not 'application/json'" do 
      request.headers["Content-Type"] = "multipart/form-data"
      post :register, params: valid_device

      expect(response).to have_http_status(500)
    end

  end
  
  describe "post /api/alive" do
    let(:valid_device) do 
      Device.create(carrier: "Verizon", phone_number: "+12345556789")
    end

    let(:disabled_device) do
      Device.create(carrier: "Verizon", phone_number: "+12345556789", disabled_at: DateTime.now)
    end

    it "creates a new heartbeat for the device" do
      # test counts how many heartbeats belong to this device
      # then creates a new one via post request to '/api/alive'
      # then checks that the number of heartbeats belonging to this device has increased by 1

      request.headers["Content-Type"] = "application/json"
      initial_heartbeats = Device.find(valid_device.id).heartbeats.length
      post :alive, params: { device_id: valid_device.id }
      updated_heartbeats = Device.find(valid_device.id).heartbeats.length

      expect(updated_heartbeats).to eq(initial_heartbeats + 1)
    end

    it "responds with an http status of 'created'" do
      request.headers["Content-Type"] = "application/json"
      post :alive, params: { device_id: valid_device.id}

      expect(response).to have_http_status(201)
    end

    it "responds with an empty object" do
      request.headers["Content-Type"] = "application/json"
      post :alive, params: { device_id: valid_device.id }

      expect(JSON.parse(response.body)).to be_empty
    end
    
    it "responds with an error message if disabled_at is not nil" do
      request.headers["Content-Type"] = "application/json"
      post :alive, params: { device_id: disabled_device.id }

      expect(JSON.parse(response.body)).to have_key("error")
      expect(JSON.parse(response.body)["error"]).to eq("unauthorized: device has been terminated")
    end

    it "responds with an http status of 500 when disabled_at is not nil" do
      request.headers["Content-Type"] = "application/json"
      post :alive, params: { device_id: disabled_device.id }

      expect(response).to have_http_status(500)
    end

    it "responds with an error message if the device id is invalid" do
      request.headers["Content-Type"] = "application/json"
      post :alive, params: { device_id: 'alsdkfjaowin' }

      expect(JSON.parse(response.body)).to have_key("error")
      expect(JSON.parse(response.body)["error"]).to eq("device not found")
    end

    it "responds with an http status of 500 if the device id is invalid" do
      request.headers["Content-Type"] = "application/json"
      post :alive, params: { device_id: 'alsdkfjaowin' }

      expect(response).to have_http_status(500)
    end

    it "responds with an error message if the 'Content-Type' header is not 'application/json'" do
      request.headers["Content-Type"] = "multipart/form-data"

      post :alive, params: { device_id: valid_device.id }
      
      expect(JSON.parse(response.body)).to have_key("error")
      expect(JSON.parse(response.body)["error"]).to eq("incorrect request headers")
    end

    it "responds with an http status of 500 if the 'Content-Type' header is not 'application/json'" do 
      request.headers["Content-Type"] = "multipart/form-data"

      post :alive, params: { device_id: valid_device.id }
      
      expect(response).to have_http_status(500)
    end
  end  

  describe "post /api/report" do
    let(:valid_device) do 
      Device.create(carrier: "Verizon", phone_number: "+12345556789")
    end

    let(:disabled_device) do
      Device.create(carrier: "Verizon", phone_number: "+12345556789", disabled_at: DateTime.now)
    end

    it "creates a new report for the device" do
      # test counts how many reports belong to this device
      # then creates a new one via post request to '/api/report'
      # then checks that the number of reports belonging to this device has increased by 1

      request.headers["Content-Type"] = "application/json"
      initial_reports = Device.find(valid_device.id).reports.length
      post :report, params: { device_id: valid_device.id }
      updated_reports = Device.find(valid_device.id).reports.length

      expect(updated_reports).to eq(initial_reports + 1)
    end

    it "responds with an http status of 'created'" do
      request.headers["Content-Type"] = "application/json"
      post :report, params: { device_id: valid_device.id}

      expect(response).to have_http_status(201)
    end

    it "responds with an empty object" do
      request.headers["Content-Type"] = "application/json"
      post :report, params: { device_id: valid_device.id }
      expect(JSON.parse(response.body)).to be_empty
    end

    it "responds with an error message if disabled_at is not nil" do
      request.headers["Content-Type"] = "application/json"
      post :report, params: { device_id: disabled_device.id }

      expect(JSON.parse(response.body)).to have_key("error")
      expect(JSON.parse(response.body)["error"]).to eq("unauthorized: device has been terminated")
    end

    it "responds with an http status of 500 if disabled_at is not nil" do
      request.headers["Content-Type"] = "application/json"
      post :report, params: { device_id: disabled_device.id }

      expect(response).to have_http_status(500)
    end

    it "responds with an error message if the device id is invalid" do
      request.headers["Content-Type"] = "application/json"
      post :report, params: { device_id: 'alsdkfjaowin' }

      expect(JSON.parse(response.body)).to have_key("error")
      expect(JSON.parse(response.body)["error"]).to eq("device not found")
    end

    it "responds with an http status of 500 if the device id is invalid" do
      request.headers["Content-Type"] = "application/json"
      post :report, params: { device_id: 'alsdkfjaowin' }

      expect(response).to have_http_status(500)
    end

    it "responds with an error message if the 'Content-Type' header is not 'application/json'" do
      request.headers["Content-Type"] = "multipart/form-data"

      post :report, params: { device_id: valid_device.id }
      
      expect(JSON.parse(response.body)).to have_key("error")
      expect(JSON.parse(response.body)["error"]).to eq("incorrect request headers")
    end

    it "responds with an http status of 500 if the 'Content-Type' header is not 'application/json'" do 
      request.headers["Content-Type"] = "multipart/form-data"

      post :report, params: { device_id: valid_device.id }
      
      expect(response).to have_http_status(500)
    end
  end

  describe "patch /api/terminate" do
    let(:valid_device) do 
      Device.create(carrier: "Verizon", phone_number: "+12345556789")
    end

    let(:disabled_device) do
      Device.create(carrier: "Verizon", phone_number: "+12345556789", disabled_at: DateTime.now)
    end

    it "updates disabled_at to current timestamp" do
      # test disables device via patch request to '/api/terminate'
      # then finds device in the db 
      # then confirms that disabled_at is no longer nil

      request.headers["Content-Type"] = "application/json"
      patch :terminate, params: { device_id: valid_device.id }
      updated_device = Device.find(valid_device.id)

      expect(updated_device.disabled_at).to_not eq(nil)
    end

    it "responds with an http status of 'ok'" do
      request.headers["Content-Type"] = "application/json"
      patch :terminate, params: { device_id: valid_device.id}

      expect(response).to have_http_status(200)
    end

    it "responds with an empty object" do
      request.headers["Content-Type"] = "application/json"
      patch :terminate, params: { device_id: valid_device.id }

      expect(JSON.parse(response.body)).to be_empty
    end

    it "responds with an error message if device has previously been terminated" do
      request.headers["Content-Type"] = "application/json"
      patch :terminate, params: { device_id: disabled_device.id }

      expect(JSON.parse(response.body)).to have_key("error")
      expect(JSON.parse(response.body)["error"]).to eq("unauthorized: device has been terminated")
    end

    it "responds with an http status of 500 if device has previously been terminated" do
      request.headers["Content-Type"] = "application/json"
      patch :terminate, params: { device_id: disabled_device.id }

      expect(response).to have_http_status(500)
    end

    it "responds with an error message if the device id is invalid" do
      request.headers["Content-Type"] = "application/json"
      patch :terminate, params: { device_id: 'alsdkfjaowin' }

      expect(JSON.parse(response.body)).to have_key("error")
      expect(JSON.parse(response.body)["error"]).to eq("device not found")
    end

    it "responds with an http status of 500 if the device id is invalid" do
      request.headers["Content-Type"] = "application/json"
      patch :terminate, params: { device_id: 'alsdkfjaowin' }

      expect(response).to have_http_status(500)
    end

    it "responds with an error message if the 'Content-Type' header is not 'application/json'" do
      request.headers["Content-Type"] = "multipart/form-data"

      patch :terminate, params: { device_id: valid_device.id }
      
      expect(JSON.parse(response.body)).to have_key("error")
      expect(JSON.parse(response.body)["error"]).to eq("incorrect request headers")
    end

    it "responds with an http status of 500 if the 'Content-Type' header is not 'application/json'" do 
      request.headers["Content-Type"] = "multipart/form-data"

      patch :terminate, params: { device_id: valid_device.id }
      
      expect(response).to have_http_status(500)
    end
  end
end