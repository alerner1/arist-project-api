# add validations and appropriate json responses
# adjust alive and report to use nested attributes instead?
# figure out private methods for nested attributes
# private method for find

module Api
  class DevicesController < ApplicationController
    before_action :check_device_exists, except: [:register]
    before_action :find_device, except: [:register]
    before_action :check_authorization, except: [:register]

    # creates a new device
    def register
      @device = Device.create(devices_params)
      if @device.valid?
        render json: @device, status: :created
      else
        render json: { error: 'failed to register device' }, status: :internal_server_error
      end
    end

    # creates a new heartbeat that belongs to device
    def alive
      @heartbeat = Heartbeat.create(heartbeats_params)
      if @heartbeat.valid?
        render json: {}, status: :created
      else
        render json: { error: 'failed to create heartbeat' }, status: :internal_server_error
      end
    end

    # creates a new report that belongs to device
    def report
      @report = Report.create(reports_params)
      if @report.valid?
        render json: {}, status: :created
      else
        render json: { error: 'failed to create report' }, status: :internal_server_error
      end
    end

    # terminates device by updating disabled_at to current date/time
    def terminate
      @device.update(disabled_at: DateTime.now)
      if @device.save
        render json: {}, status: :ok
      else
        render json: { error: 'failed to terminate device' }, status: :internal_server_error
      end
    end

    private

    # permitted params for creating a new device
    def devices_params
      params.require(:device).permit(:phone_number, :carrier)
    end

    # permitted params for creating a new heartbeat
    def heartbeats_params
      params.permit(:device_id)
    end

    # permitted params for creating a new report
    def reports_params
      params.permit(:device_id, :message, :sender)
    end

    # find a device by id
    # returns device
    def find_device
      @device = Device.find(params[:device_id])
    end

    # check if a device exists
    # if device does not exist, renders error message
    def check_device_exists
      render json: { error: 'device not found' }, status: :internal_server_error unless Device.exists?(params[:device_id])
    end

    # check if a device has previously been terminated
    # if device has been terminated, renders error message
    def check_authorization
      render json: { error: 'unauthorized: device has been terminated' }, status: :internal_server_error unless @device.disabled_at == nil
    end
  end
end