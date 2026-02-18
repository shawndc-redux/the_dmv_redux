require 'spec_helper'

RSpec.describe VehicleFactory do
  describe 'factory initialization' do
    it 'can create vehicles' do
      factory = VehicleFactory.new
      wa_ev_registrations = DmvDataService.new.wa_ev_registrations
      vehicles = factory.create_vehicles(wa_ev_registrations)

      vehicles.each do |vehicle|
        expect(vehicle.engine).to eq(:ev)
        expect(vehicle).to be_an_instance_of(Vehicle)
      end

      expect(vehicles.count).to eq(1000)
    end
  end
end