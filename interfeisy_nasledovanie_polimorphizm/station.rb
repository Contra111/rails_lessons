class Station
  # у этого класса нет приватных методов, все они используются для работы с экземпляром класса
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
    trains_names = trains.collect { |x| x.number}
    if trains_names.include?(train.number) && train.current_station == self.name
      @trains = @trains.select { |x| x.number != train.number}
      train.set_station(nil)
    end
  end
  def train_types
    types = {}
    @trains.each { |x| types[x.type] = 0}
    @trains.each { |x| types[x.type] += 1}
    types
  end
  def show_trains
    @trains.each do |x|
      puts "#{x.number} - #{x.type}"
    end
  end
end
