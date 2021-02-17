module Api
  class DevicesController < ApplicationController
    def create
      @device = Device.create(devices_params)
    end

    def alive
      device = Device.find(params[:device_id])
      @heartbeat = Heartbeat.create(device: device)
      render json: @heartbeat
    end

    private

    def devices_params
      params.require(:device).permit(:phone_number, :carrier)
    end
  end
end