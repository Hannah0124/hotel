require_relative 'test_helper'

describe "Reservation class" do 
  
  # Arrange 
  before do 
    date_range = Hotel::DateRange.new(Date.new(2020, 3, 20), Date.new(2020, 3, 27))

    hotel_manager = Hotel::HotelManager.new()

    room_id = hotel_manager.available_room_ids(date_range)[0]
    room = hotel_manager.find_room_by_id(room_id)

    @reservation = Hotel::Reservation.new(date_range, room: room)
  end

  describe "#initialize" do 
    it "creates date_range, room instance, id, block" do 
      expect(@reservation).must_respond_to :date_range
      expect(@reservation).must_respond_to :room
      expect(@reservation).must_respond_to :id
      expect(@reservation).must_respond_to :block

      expect(@reservation.date_range).must_be_kind_of Hotel::DateRange
      expect(@reservation.room).must_be_kind_of Hotel::Room

      expect(@reservation.date_range.start_date).must_equal Date.new(2020, 3, 20)
      expect(@reservation.date_range.end_date).must_equal Date.new(2020, 3, 20) + 7
      expect(@reservation.room.id).must_equal 1
      expect(@reservation.id).must_be_kind_of String
      expect(@reservation.id.length).must_equal 6
      expect(@reservation.block).must_be_nil
    end 
  end 


   # I can get the total cost for a given reservation
   describe "#individual_total_cost" do 
     it "returns the correct total cost for a given reservation" do
       expect(@reservation.individual_total_cost).must_be_instance_of Float

       expect(@reservation.individual_total_cost).must_be_close_to (7 * 200.00), 0.01
     end 
    end 

   describe "#block_total_cost" do 
     it "returns the correct total cost for a given block reservation" do 

       date_range = Hotel::DateRange.new(Date.new(2020, 5, 6), Date.new(2020, 5, 12))

       
       rooms = []
       5.times do |i|
        room = Hotel::Room.new(id: i + 1)
        rooms << room
       end 

       block = Hotel::Block.new(date_range, rooms: rooms)

       reservation = Hotel::Reservation.new(date_range, block: block) 

       expect(reservation.block_total_cost).must_be_close_to (160.00 * 5 * 6), 0.01   
     end 
   end 

   describe ".generate_id" do 
     it "returns a non consecutive random id with 6 digits as a string" do 
       expect(Hotel::Reservation.generate_id.length).must_equal 6

       expect(Hotel::Reservation.generate_id).must_be_kind_of String
     end 


     # TO DO
     # Question: I'm not sure how to check this
    #  it "re-generate an ID if there was the same ID in our system" do 
    #    @@ids = ["222222"]

    #    p "Hotel::Reservation.ids"
    #    p Hotel::Reservation.ids
    #  end 
    end 

end 