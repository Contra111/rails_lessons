class Station
  attr_reader :name, :trains

  Train_data = Struct.new(:number, :type)

  def initialize(name)
    @name = name
    @trains = []
  end

  def take(train)
    if !trains.include?(train) && train.current_station == nil
      @trains << Train_data.new(train.number, train.type)
      train.set_station(self)
    end
  end

  def send(train)
    trains.delete(train)
  end

  def train_types
    types = {}
    @trains.each { |x| types[x.type] = 0}
    @trains.each { |x| types[x.type] += 1}
    types
  end

end

class Train
  attr_reader :cars, :speed, :number, :current_station, :type

  def initialize(number, type, cars)
    @number = number
    @type = type
    @cars = cars
    @speed = 0
    @current_station = nil
    @route = nil
    @current_station_index = nil
  end

  def speed_up(up)
    @speed += up
  end

  def speed_down
    @speed = 0
  end

  def add_car
    if @speed == 0 
      @cars += 1
    end
  end

  def remove_car
    if @cars != 0 && @speed == 0
      @cars -= 1
    end
  end

  def set_station(station)
    
    puts "Train #{@number} goes from "\
         "#{@current_station == nil ? 'nil' : @current_station} to "\
         "#{station == nil ? 'nil' : station.name} "
    @current_station = station == nil ? nil : station.name
  end

  def set_route(route)
    @route = route
    @route.stations_list[0].take(self) 
    @current_station_index = 0 
  end

  def move_forward
    if @current_station == @route.stations_list[-1].name
      puts "You already on last station!"
    else
      @route.stations_list.each_with_index do |x, i|
        if x.name == @current_station
          @current_station_index = i
        end
      end
      puts @current_station_index
      @route.stations_list[@current_station_index].send(self)
      @route.stations_list[@current_station_index + 1].take(self)
      @current_station_index += 1
    end
  end

  def move_back
    if @current_station == @route.stations_list[0].name
      puts "You already on first station!"
    else
      @route.stations_list.each_with_index do |x, i|
        if x.name == @current_station
          @current_station_index = i
        end
      end
      puts @current_station_index
      @route.stations_list[@current_station_index].send(self)
      @route.stations_list[@current_station_index - 1].take(self)
      @current_station_index -= 1
    end
  end

  def closest_stations
    if @current_station_index == nil
      puts "train is not on station!"
    else
      if @current_station_index == 0
        puts "current station #{@route.stations_list[@current_station_index].name} is first on Route"
        puts "next station is #{@route.stations_list[@current_station_index + 1].name}"
      elsif @current_station_index == @route.stations_list.length - 1
        puts "previous station is #{@route.stations_list[@current_station_index - 1].name}"
        puts "current station #{@route.stations_list[@current_station_index].name} if last on Route"
      else
        puts "previous station is #{@route.stations_list[@current_station_index - 1].name}"
        puts "current station is #{@route.stations_list[@current_station_index].name}"
        puts "next station is #{@route.stations_list[@current_station_index].name}"
      end
    end
  end

end

class Route
  attr_reader :first_station, :stations_list
  def initialize(first_station, last_station)
    @stations_list = [first_station, last_station]
  end

  def between_station_add(station)
    @stations_list = @stations_list.insert(-2, station)
  end

  def between_station_remove(station)
    stations_list.delete(station)
  end

  def show_route
    @stations_list.each { |x| puts x.name}
  end

end

#Тестовые данные для irb

station1 = Station.new("Station 1")
station2 = Station.new("Station 2")
station3 = Station.new("Station 3")
station4 = Station.new("Station 4")
station5 = Station.new("Station 5")
station6 = Station.new("Station 6")
station7 = Station.new("Station 7")
station8 = Station.new("Station 8")

route1 = Route.new(station1, station2)
route1.between_station_add(station4)
route1.between_station_add(station3)
route1.between_station_add(station6)
route1.between_station_add(station8)
route2 = Route.new(station4, station8)
route2.between_station_add(station5)
route2.between_station_add(station7)
route2.between_station_add(station2)
train1 = Train.new("Train 1", "Pass", 30)
train2 = Train.new("Train 2", "Pass", 20)
train3 = Train.new("Train 3", "Cargo", 70)