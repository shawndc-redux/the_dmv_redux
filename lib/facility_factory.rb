class FacilityFactory
  attr_reader :facilities

  def initialize
    @facilities = []
  end

  def create_facilities(locations)
    locations.map do |location|
      if location[:state].include?("CO")
        build_co_facilities(location)
      elsif location[:state].include?("NY")
        build_ny_facilities(location)
      elsif location[:state].include?("MO")
        build_mo_facilities(location)
      end
    end
  end

  def build_services(new_facility, services_p)
      new_facility.services = 
    services_p.gsub(',' , "")
      .gsub(';' , "").gsub('vehicle' , "").gsub('VIN' , "").split
  end

  def build_co_facilities(location)
    new_facility = Facility.new({
      name: location[:dmv_office],
      address: "#{location[:address_li]} #{location[:address_1]} #{location[:city]}, #{location[:state]} #{location[:zip]}",
      phone: location[:phone]
    })
    
    build_services(new_facility, location[:services_p])
    facilities << new_facility
  end
  
  def build_ny_facilities(location)
    new_facility = Facility.new({
      name: location[:office_name],
      address: "#{location[:street_address_line_1]} #{location[:street_address_line_2]} #{location[:city]}, #{location[:state]} #{location[:zip]}",
      phone: location[:public_phone_number]
    })

    facilities << new_facility 
  end
  
  def build_mo_facilities(location)
    new_facility = Facility.new({
      name: location[:dmv_office],
      address: "#{location[:address_li]} #{location[:address_1]} #{location[:city]}, #{location[:state]} #{location[:zip]}",
      phone: location[:phone]
    })
    build_services(new_facility, location[:services_p])
    facilities << new_facility

  end
end