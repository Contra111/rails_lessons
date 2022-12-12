require_relative './instance_counter.rb'

class Route

  include InstanceCounter

  # у этого класса нет приватных методов, все они используются для работы с экземпляром класса
  attr_reader :first_station, :stations_list

  def initialize(first_station, last_station)
    @stations_list = [first_station, last_station]
    register_instance
  end

  def between_station_add(station)
    if !@stations_list.include?(station)
      @stations_list = @stations_list.insert(-2, station)
      puts "Станция #{station.name} успешно добавлена!"
    else
      puts 'Эта станция уже есть на маршруте!'
    end
  end

  def between_station_remove(station)
    if stations_list.include?(station)
      if @stations_list.length != 2
        first = @stations_list[0]
        last = @stations_list[-1]
        @stations_list = @stations_list[1..-2].select { |x| x.name != station.name}
        @stations_list = @stations_list.push(last)
        @stations_list = @stations_list.unshift(first)
        puts "Станция успешно удалена!"
      else 
        puts "У маршрута всего две остановки, нечего удалять!"
      end
    else
      puts 'Выбранной станции нет в маршруте, поэтому ее нельзя удалить!'
    end
  end

  def show_route
    @stations_list.each { |x| puts x.name}
  end

end