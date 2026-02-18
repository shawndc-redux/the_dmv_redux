require 'spec_helper'

RSpec.describe Facility do
  before(:each) do
    @facility = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
  end
  describe '#initialize' do
    it 'can initialize' do
      expect(@facility).to be_an_instance_of(Facility)
      expect(@facility.name).to eq('DMV Tremont Branch')
      expect(@facility.address).to eq('2855 Tremont Place Suite 118 Denver CO 80205')
      expect(@facility.phone).to eq('(720) 865-4600')
      expect(@facility.services).to eq([])
    end
  end

  describe '#add service' do
    it 'can add available services' do
      expect(@facility.services).to eq([])
      @facility.add_service('New Drivers License')
      @facility.add_service('Renew Drivers License')
      @facility.add_service('Vehicle Registration')
      expect(@facility.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
    end
  end

  describe '#vehicle registration' do
    before(:each) do
      @facility_1 = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
      @facility_2 = Facility.new({name: 'DMV Northeast Branch', address: '4685 Peoria Street Suite 101 Denver CO 80239', phone: '(720) 865-4600'})
      @cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
      @bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
      @camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
    end

    it 'can register a vehicle' do
      @facility_1.add_service('Vehicle Registration')

      expect(@facility_1.services).to eq(['Vehicle Registration'])

      expect(@cruz.registration_date).to eq nil
      expect(@facility_1.registered_vehicles).to eq([])
      expect(@facility_1.collected_fees).to eq 0

      @facility_1.register_vehicle(@cruz)
      
      expect(@cruz.registration_date).to eq(Date.today)
      expect(@cruz.plate_type).to eq(:regular)
      expect(@facility_1.registered_vehicles).to eq([@cruz])
      expect(@facility_1.collected_fees).to eq(100)
      
      
      @facility_1.register_vehicle(@camaro)
      
      expect(@camaro.registration_date).to eq(Date.today)
      expect(@camaro.plate_type).to eq(:antique)
      
      @facility_1.register_vehicle(@bolt)
      
      expect(@bolt.registration_date).to eq(Date.today)
      expect(@bolt.plate_type).to eq(:ev)
      expect(@facility_1.registered_vehicles).to eq([@cruz, @camaro, @bolt])
      expect(@facility_1.collected_fees).to eq(325)
      expect(@facility_2.registered_vehicles).to eq([])
      expect(@facility_2.services).to eq([])
      
      @facility_2.register_vehicle(@bolt)
      
      expect(@facility_2.registered_vehicles).to eq([])
      expect(@facility_2.collected_fees).to eq(0)
    end
  end

  describe '#Getting a Drivers License' do
    before(:each) do
      @registrant_1 = Registrant.new('Bruce', 18, true )
      @registrant_2 = Registrant.new('Penny', 16 )
      @registrant_3 = Registrant.new('Tucker', 15 )
      @facility_1 = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
      @facility_2 = Facility.new({name: 'DMV Northeast Branch', address: '4685 Peoria Street Suite 101 Denver CO 80239', phone: '(720) 865-4600'})
    end

    describe '#written test' do

      it 'can administer a written test' do
        expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
        expect(@registrant_1.permit?).to be_truthy
        
        @facility_1.administer_written_test(@registrant_1)
        
        expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
        
        @facility_1.add_service('Written Test')
        @facility_1.administer_written_test(@registrant_1)
        
        expect(@registrant_1.license_data).to eq({:written=>true, :license=>false, :renewed=>false}) 
      end
      
      it 'checks that registrant has a permit before administering written test' do
        expect(@registrant_2.age).to eq 16
        expect(@registrant_2.permit?).to eq false
        
        @facility_1.add_service('Written Test')
        @facility_1.administer_written_test(@registrant_2)
        
        expect(@registrant_2.license_data).to eq({:written=>false, :license=>false, :renewed=>false}) 
        
        @registrant_2.earn_permit
        @facility_1.administer_written_test(@registrant_2)
        
        expect(@registrant_2.license_data).to eq({:written=>true, :license=>false, :renewed=>false}) 
      end
      
      it 'checks that a registrant is 16 or older before administering written test' do
        @facility_1.add_service('Written Test')
        
        expect(@registrant_3.age).to eq 15
        expect(@registrant_3.permit?).to eq false
        
        @facility_1.administer_written_test(@registrant_3)
        @registrant_3.earn_permit
        @facility_1.administer_written_test(@registrant_3)
        
        expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false}) 
      end
    end
    
    describe '#road test' do
      before(:each) do
        @facility_1.add_service('Written Test')
        @registrant_2.earn_permit
        @facility_1.administer_written_test(@registrant_2)

      end

      it 'will not administer road test to underage registrant' do
        @facility_1.administer_road_test(@registrant_3)
        @registrant_3.earn_permit
        @facility_1.administer_road_test(@registrant_3)
        
        expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false}) 
      end

      it 'can administer a road test if service is available' do        
        @facility_1.administer_road_test(@registrant_1)
        
        expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false}) 
        
        @facility_1.add_service('Road Test')
        
        expect(@facility_1.services).to eq(["Written Test", "Road Test"])
        
        @facility_1.administer_written_test(@registrant_1)
        @facility_1.administer_road_test(@registrant_1)
        
        expect(@registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>false}) 
        
        @facility_1.administer_road_test(@registrant_2)
        
        expect(@registrant_2.license_data).to eq({:written=>true, :license=>true, :renewed=>false}) 
      end 
    end
    
    describe '#renew license' do
      before(:each) do
        @facility_1.add_service('Written Test')
        @facility_1.add_service('Road Test')
        @registrant_2.earn_permit
        @facility_1.administer_written_test(@registrant_2)
        @facility_1.administer_written_test(@registrant_1)
        @facility_1.administer_road_test(@registrant_1)
        @facility_1.administer_road_test(@registrant_2)      
      end
      
      it 'can renew a drivers license' do
        expect(@registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>false}) 
        expect(@registrant_2.license_data).to eq({:written=>true, :license=>true, :renewed=>false}) 
        
        @facility_1.renew_drivers_license(@registrant_1)
        
        expect(@registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>false}) 
        
        @facility_1.add_service('Renew License')     
        @facility_1.renew_drivers_license(@registrant_1)
        
        expect(@registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>true}) 
      end
      
      it 'checks that a driver has a license before renewing' do
        @facility_1.add_service('Renew License')     
        @facility_1.renew_drivers_license(@registrant_3)
        
        expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false}) 
        
        @facility_1.renew_drivers_license(@registrant_2)
        
        expect(@registrant_2.license_data).to eq({:written=>true, :license=>true, :renewed=>true}) 
      end
    end
  end
end
