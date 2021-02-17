# add validations and appropriate json responses
# adjust alive and report to use nested attributes instead?
# figure out private methods for nested attributes
# private method for find
# maybe rename methods to match routes rather than rest

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

    def update
      device = Device.find(params[:device_id])
      device.update(disabled_at: DateTime.now)
      if device.save
        render json: device, status: :accepted
      else
        render json: { error: 'failed to terminate device' }, status: :not_acceptable
      end
    end

    private

    def devices_params
      params.require(:device).permit(:phone_number, :carrier)
    end
  end
end