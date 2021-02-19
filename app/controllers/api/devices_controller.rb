# add validations and appropriate json responses
# adjust alive and report to use nested attributes instead?
# figure out private methods for nested attributes
# private method for find

module Api
  class DevicesController < ApplicationController
    def register
      @device = Device.create(devices_params)
      if @device.valid?
        render json: @device, status: :created
      else
        render json: { error: 'failed to register device' }, status: :internal_server_error
      end
    end

    def alive
      if Device.exists?(id: params[:device_id])
        if check_authorization(params[:device_id])
          device = find_device(params[:device_id])
          @heartbeat = Heartbeat.create(device: device)
          if @heartbeat.valid?
            render json: {}, status: :created
          else
            render json: { error: 'failed to create heartbeat' }, status: :internal_server_error
          end
        else
          render json: { error: 'device has been terminated' }, status: :internal_server_error
        end
      else
        render json: { error: 'device not found' }, status: :internal_server_error
      end
    end

    def report
      device = Device.find(params[:device_id])
      @report = Report.create(device: device, message: params[:message], sender: params[:sender])
      render json: @report
    end

    def terminate
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

    def find_device(device_id)
      device = Device.find(device_id)
    end

    def check_authorization(device_id)
      device = find_device(device_id)
      device.disabled_at == nil ? true : false
    end
  end
end