class Station
  attr_reader :name, :trains

  Train_data = Struct.new(:number, :type)

  def initialize(name)
    @name = name
    @trains = []
  end

  def take(train)
    if !trains.include?(train) && train.currentStation == nil
      @trains << Train_data.new(train.number, train.type)
      train.setStation(self)
    end
  end

  def send(train)
    trains_names = trains.collect { |x| x.number}
    if trains_names.include?(train.number) && train.currentStation == self.name
      @trains = @trains.select { |x| x.number != train.number}
      train.setStation(nil)
    end
  end

  def train_types
    types = {}
    @trains.each { |x| types[x.type] = 0}
    @trains.each { |x| types[x.type] += 1}
    types
  end

end

class Train
  attr_reader :cars, :speed, :number, :currentStation, :type

  def initialize(number, type, cars)
    @number = number
    @type = type
    @cars = cars
    @speed = 0
    @currentStation = nil
    @route = nil
    @currentStationIndex = nil
  end

  def speedUp(up)
    @speed += up
  end

  def speedDown
    @speed = 0
  end

  def addCar
    if @speed == 0 
      @cars += 1
    end
  end

  def removeCar
    if @cars != 0 && @speed == 0
      @cars -= 1
    end
  end

  def setStation(station)
    
    puts "Train #{@number} goes from "\
         "#{@currentStation == nil ? 'nil' : @currentStation} to "\
         "#{station == nil ? 'nil' : station.name} "
    @currentStation = station == nil ? nil : station.name
  end

  def setRoute(route)
    @route = route
    @route.stationsList[0].take(self) 
    @currentStationIndex = 0 
  end

  def moveForward
    if @currentStation == @route.stationsList[-1].name
      puts "You already on last station!"
    else
      @route.stationsList.each_with_index do |x, i|
        if x.name == @currentStation
          @currentStationIndex = i
        end
      end
      puts @currentStationIndex
      @route.stationsList[@currentStationIndex].send(self)
      @route.stationsList[@currentStationIndex + 1].take(self)
      @currentStationIndex += 1
    end
  end

  def moveBack
    if @currentStation == @route.stationsList[0].name
      puts "You already on first station!"
    else
      @route.stationsList.each_with_index do |x, i|
        if x.name == @currentStation
          @currentStationIndex = i
        end
      end
      puts @currentStationIndex
      @route.stationsList[@currentStationIndex].send(self)
      @route.stationsList[@currentStationIndex - 1].take(self)
      @currentStationIndex -= 1
    end
  end

  def closestStations
    if @currentStationIndex == nil
      puts "train is not on station!"
    else
      if @currentStationIndex == 0
        puts "current station #{@route.stationsList[@currentStationIndex].name} is first on Route"
        puts "next station is #{@route.stationsList[@currentStationIndex + 1].name}"
      elsif @currentStationIndex == @route.stationsList.length - 1
        puts "previous station is #{@route.stationsList[@currentStationIndex - 1].name}"
        puts "current station #{@route.stationsList[@currentStationIndex].name} if last on Route"
      else
        puts "previous station is #{@route.stationsList[@currentStationIndex - 1].name}"
        puts "current station is #{@route.stationsList[@currentStationIndex].name}"
        puts "next station is #{@route.stationsList[@currentStationIndex].name}"
      end
    end
  end

end

class Route
  attr_reader :firstStation, :stationsList
  def initialize(firstStation, lastStation)
    @stationsList = [firstStation, lastStation]
  end

  def betweenStationAdd(station)
    if !@stationsList.include?(station)
      @stationsList = @stationsList.insert(-2, station)
    end
  end

  def betweenStationRemove(station)
    if @stationsList.length != 2
      first = @stationsList[0]
      last = @stationsList[-1]
      @stationsList = @stationsList[1..-2].select { |x| x.name != station.name}
      @stationsList = @stationsList.push(last)
      @stationsList = @stationsList.unshift(first)
    else 
      puts "Route contains only 2 stations"
    end
  end

  def showRoute
    @stationsList.each { |x| puts x.name}
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
route1.betweenStationAdd(station4)
route1.betweenStationAdd(station3)
route1.betweenStationAdd(station6)
route1.betweenStationAdd(station8)
route2 = Route.new(station4, station8)
route2.betweenStationAdd(station5)
route2.betweenStationAdd(station7)
route2.betweenStationAdd(station2)
train1 = Train.new("Train 1", "Pass", 30)
train2 = Train.new("Train 2", "Pass", 20)
train3 = Train.new("Train 3", "Cargo", 70)



=begin
не понятно, когда / как нужно передавать в методе сам объект, а когда просто его поля
Например, Station.take принимает по сути поля объекта Train
А в Route.initialize нужно передавать объект Station т.к после создания объекта Route
уже при вызове Train.setRoute, до Station которые в нем уже будет не достучаться, если 
планируется использовать их методы в дальнейшем. А если бы станции хранили не поля поезда,
а сами объекты то получился бы замкнутый рекурсивный объект где
поезда ссылаются на маршрут, маршрут на станции, станции на поезда и т.д
=end