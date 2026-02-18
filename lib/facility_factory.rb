class FacilityFactory
  attr_reader :facilities

  def initialize
    @facilities = []
  end

  def create_facilities(locations)
    locations.map do |location|
      new_facility = Facility.new({
        name: location[:dmv_office],
        address: "#{location[:address_li]} #{location[:address_1]} #{location[:city]}, #{location[:state]} #{location[:zip]}",
        phone: location[:phone]
      })
      build_services(new_facility, location[:services_p])
      facilities << new_facility
    end
  end

  def build_services(new_facility, services_p)
      new_facility.services = 
    services_p.gsub(',' , "")
      .gsub(';' , "").gsub('vehicle' , "").gsub('VIN' , "").split
  end
end