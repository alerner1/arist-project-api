# add validations and appropriate json responses
# adjust alive and report to use nested attributes instead?
# figure out private methods for nested attributes

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

    def report
      device = Device.find(params[:device_id])
      @report = Report.create(device: device, message: params[:message], sender: params[:sender])
      render json: @report
    end

    private

    def devices_params
      params.require(:device).permit(:phone_number, :carrier)
    end
  end
end