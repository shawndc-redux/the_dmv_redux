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
end