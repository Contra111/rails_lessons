
# irb test data 
# type source('test_data.rb') in irb to load data and use it for testing

station1 = Station.new("Station 1")
station2 = Station.new("Station 2")
station3 = Station.new("Station 3")
station4 = Station.new("Station 4")
station5 = Station.new("Station 5")
station6 = Station.new("Station 6")
station7 = Station.new("Station 7")
station8 = Station.new("Station 8")
station9 = Station.new("Station 9")

route1 = Route.new(station1, station2)
route1.between_station_add(station4)
route1.between_station_add(station3)
route1.between_station_add(station6)
route1.between_station_add(station8)

route2 = Route.new(station4, station8)
route2.between_station_add(station5)
route2.between_station_add(station7)
route2.between_station_add(station2)

train1 = PassengerTrain.new("Train 1")
train2 = CargoTrain.new("Train 2")