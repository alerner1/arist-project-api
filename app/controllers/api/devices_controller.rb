module Api
  class DevicesController < ApplicationController
    def create
      @device = Device.create(devices_params)
    end

    private

    def devices_params
      params.require(:device).permit(:phone_number, :carrier)
    end
  end
end