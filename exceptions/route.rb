require_relative './instance_counter.rb'

class Route

  include InstanceCounter

  # у этого класса нет приватных методов, все они используются для работы с экземпляром класса
  attr_reader :first_station, :stations_list

  def initialize(first_station, last_station)
    @stations_list = [first_station, last_station]
    register_instance
    validate!
  end

  def between_station_add(station)
    if !@stations_list.include?(station)
      @stations_list = @stations_list.insert(-2, station)
      true # для отладки
    else
      false # для отладки
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
        true
        # puts "Станция успешно удалена!"
      else 
        false
        # puts "У маршрута всего две остановки, нечего удалять!"
      end
    else
      false
      # puts 'Выбранной станции нет в маршруте, поэтому ее нельзя удалить!'
    end
  end

  def show_route
    @stations_list.each { |x| puts x.name}
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  protected

  def validate!
    if stations_list.find { |x| x.class != Station }
      raise 'Оба аргумента должны быть станциями!'
    end
  end

end