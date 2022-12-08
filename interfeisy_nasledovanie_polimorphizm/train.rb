class Train
  # у этого класса нет приватных методов, все они используются для работы с экземпляром класса
  attr_reader :speed, :number, :current_station, :type, :cars
  def initialize(number)
    @type = nil
    @number = number
    @speed = 0
    @current_station = nil
    @route = nil
    @current_station_index = nil
    @cars = []
  end
  def speed_up(up)
    @speed += up
  end
  def speed_down
    @speed = 0
  end
  def add_car(car)
    if @speed == 0 && car.type == @type && car.current_train == nil
      car.current_train = self.number
      @cars << car
    end
  end
  def remove_car(car)
    if @cars.length !=0
      if @cars.include?(car) && @speed == 0
        @cars.delete(car)
        car.current_train = nil
        puts "Вагон успешно удален!"
      end
    else
      puts 'У поезда нету вагонов!'
    end
  end
  def set_station(station)
    puts "Поезд #{@number} едет из "\
         "#{@current_station == nil ? 'nil' : @current_station} в "\
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
      puts "Вы уже на последней станции!"
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
      puts "Вы уже на первой станции!"
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
      puts "Поезд в данный момент не на станции!"
    else
      if @current_station_index == 0
        puts "Текущая станция #{@route.stations_list[@current_station_index].name} первая на маршруте"
        puts "Следующая станция #{@route.stations_list[@current_station_index + 1].name}"
      elsif @current_station_index == @route.stations_list.length - 1
        puts "Предыдущая станция #{@route.stations_list[@current_station_index - 1].name}"
        puts "Текущая станция #{@route.stations_list[@current_station_index].name} последняя на маршруте"
      else
        puts "Предыдущая станция #{@route.stations_list[@current_station_index - 1].name}"
        puts "Текущая станция #{@route.stations_list[@current_station_index].name}"
        puts "Следующая станция #{@route.stations_list[@current_station_index].name}"
      end
    end
  end
  def have_a_route?
    if @route == nil
      false
    else
      true
    end
  end
end