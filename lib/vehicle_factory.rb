class VehicleFactory
  def initialize
    @vehicles = []
  end

  def create_vehicles(vehicles)
    @vehicles = vehicles.map do |vehicle|
      Vehicle.new({
        vin: vehicle[:vin_1_10],
        year: vehicle[:model_year],
        make: vehicle[:make],
        model: vehicle[:model],
        registration_date: nil,
        plate_type: nil,
        engine: :ev
      })
    end
  end
end