require 'spec_helper'

RSpec.describe FacilityFactory do
  describe '#facility creation' do
    it 'can make facilities' do 
      factory = FacilityFactory.new
      co_dmv_office_locations = DmvDataService.new.co_dmv_office_locations
      factory.create_facilities(co_dmv_office_locations)

      factory.facilities.each do |facility|
        expect(facility).to be_an_instance_of(Facility)
      end
    end
  end

  describe '#create facility objects from multiple data sources' do
    it 'can make new york facilities' do
      factory = FacilityFactory.new
      ny_dmv_office_locations = DmvDataService.new.ny_dmv_office_locations
      factory.create_facilities(ny_dmv_office_locations)

      factory.facilities.each do |facility|
        expect(facility).to be_an_instance_of(Facility)
      end
    end

    it 'can make missouri facilities' do
      # factory = FacilityFactory.new
      # factory.create_facilities(mo_dmv_office_locations)

      # factory.facilities.each do |facility|
      #   expect(facility).to be_an_instance_of(Facility)
      # end
      # mo_dmv_office_locations = DmvDataService.new.mo_dmv_office_locations
    end
  end
end