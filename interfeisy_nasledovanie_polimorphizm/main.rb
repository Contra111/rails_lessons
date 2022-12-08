require './route.rb'
require './train.rb'
require './car.rb'
require './cargo_car.rb'
require './cargo_train.rb'
require './passenger_car.rb'
require './passenger_train.rb'
require './station.rb'

input = nil
stations = []
trains = []
routes = []

while input != 9
  puts ''
  puts '1 - Создать станцию'
  puts '2 - Создать поезд'
  puts '3 - Создать маршрут и управлять станциями в нем (добавлять, удалять)'
  puts '4 - Назначить маршрут поезду'
  puts '5 - Добавить вагоны поезду'
  puts '6 - Отцепить вагоны от поезда'
  puts '7 - Переместить поезд по маршруту вперед и назад'
  puts '8 - Просмотреть список станций и списки поездов на станциях'
  puts '9 - Выход'
  puts ''
  print 'Ввод : '
  input =  gets.chomp.to_i
  puts ''
  case input
  when 1
    puts 'Создать станцию'
    puts ''
    duplicate = nil
    while duplicate != 0
      duplicate = 0
      print 'Введите название станции (уникальное): '
      station_name = gets.chomp
      stations.each do |x| 
        if x.name == station_name 
          duplicate = 1
        end
      end
      if duplicate == 1
        puts 'Станция с таким названием уже есть!'
      else 
        duplicate = 0
      end
    end
    stations << Station.new(station_name)
    puts "Станция #{station_name} успешно добавлена!"
  when 2
    puts 'Создать поезд'
    puts ''
    duplicate = nil
    while duplicate != 0
      duplicate = 0
      print 'Введите название поезда (уникальное): '
      train_name = gets.chomp
      trains.each do |x| 
        if x.number == train_name 
          duplicate = 1
        end
      end
      if duplicate == 1
        puts 'Поезд с таким названием уже есть!'
      else 
        duplicate = 0
      end
    end
    train_type = nil
    while train_type != 'грузовой' && train_type != 'пассажирский'
      print 'Введите тип поезда (грузовой / пассажирский) : '
      train_type = gets.chomp
    end
    if train_type == 'грузовой'
      trains << CargoTrain.new(train_name)
      puts "Добавлен #{train_type} поезд #{train_name}"
    end
    if train_type == 'пассажирский'
      trains << PassengerTrain.new(train_name)
      puts "Добавлен #{train_type} поезд #{train_name}"
    end
  when 3
    user_select = nil
    while user_select != 'создать' && user_select != 'управлять'
      puts 'Создать маршрут или управлять станциями в нем? (создать/управлять)'
      user_select = gets.chomp
    end
    if user_select == 'управлять'
      if routes == []
        puts 'Маршрутов еще нет'
      else
        puts 'Список маршрутов : '
        i = 0
        routes.each do |x|
          i += 1
          puts "Маршрут №#{i} : "
          x.show_route
        end
        route_number = nil
        while !(1..i).include?(route_number)
          puts 'Введите номер маршрута для изменения : '
          route_number = gets.chomp.to_i
        end
        puts 'Cтанции маршрута : '
        routes[route_number - 1].show_route
        user_select = nil
        while user_select != 'добавить' && user_select != 'удалить'
          puts 'Добавить или удалить станции из маршрута? (добавить/удалить)'
          user_select = gets.chomp
        end
        if user_select == 'добавить'
          puts 'Список станций : '
          i = 0
          stations.each do |x|
            i += 1
            puts "#{i} - #{x.name}"
          end
          station_number = nil
          while !(1..i).include?(station_number)
            puts 'Введите номер станции, которую нужно добавить (уникальную) : '
            station_number = gets.chomp.to_i
          end
          routes[route_number - 1].between_station_add(stations[station_number - 1])
        elsif user_select == 'удалить' && routes[route_number - 1].stations_list.length <= 2
          puts 'Маршрут слишком короткий, чтобы из него что-то удалять!'
        else
          puts 'Список станций : '
          i = 0
          stations.each do |x|
            i += 1
            puts "#{i} - #{x.name}"
          end
          station_number = nil
          while !(1..i).include?(station_number)
            puts 'Введите номер станции, которую нужно удалить (которая есть в маршруте) : '
            station_number = gets.chomp.to_i
          end
          routes[route_number - 1].between_station_remove(stations[station_number - 1])
        end
      end
    end
    if user_select == 'создать'
      if stations.length >= 2
        puts 'Создаем маршрут'
        puts ''
        i = 0
        puts 'Список станций : '
        stations.each do |x|
          i += 1
          puts "#{i} - #{x.name}"
        end
        first_station = -1
        while !(1..i).include?(first_station)
          puts 'Введите номер начальной станции : '
          first_station = gets.chomp.to_i
        end
        i = 0
        puts 'Список станций : '
        stations.each do |x|
          i += 1
          puts "#{i} - #{x.name}"
        end
        last_station = -1
        while !(1..i).include?(last_station)
          puts 'Введите номер конечной станции станции : '
          last_station = gets.chomp.to_i
        end
        new_route = Route.new(stations[first_station - 1], stations[last_station - 1])
        puts 'Создан маршрут : '
        new_route.show_route
        routes << new_route
      else
        puts 'Станций слишком мало, чтобы создать маршрут'
      end
    end
  when 4
    puts 'Назначить маршрут поезду'
    puts ''
    if trains == [] || routes == []
      puts 'Нету поездов или / и маршрутов'
    else
      puts 'Список поездов : '
      i = 0
      trains.each do |x|
        i += 1
        puts "#{i} - #{x.number}"
      end
      train_number = nil
      while !(1..i).include?(train_number)
        puts 'Введите номер поезда : '
        train_number = gets.chomp.to_i
      end
      puts 'Список маршрутов : '
      i = 0
      routes.each do |x|
        i += 1
        puts "Маршрут № #{i} : "
        x.show_route
      end
      route_number = nil
      while !(1..i).include?(route_number)
        puts 'Введите номер маршрута : '
        route_number = gets.chomp.to_i
      end
      puts "Назначем поезду #{trains[train_number - 1].number} следующий маршрут : "
      routes[route_number - 1].show_route
      puts ''
      trains[train_number - 1].set_route(routes[route_number - 1])
    end
  when 5
    puts 'Добавить вагоны поезду'
    puts ''
    if trains == []
      puts 'Поездов еще нет'
    else
      puts 'Список поездов : '
      i = 0
      trains.each do |x| 
        i += 1
        puts "#{i} - #{x.number}"
      end
      train_number = nil
      while !(1..i).include?(train_number)
        puts 'Введите номер нужного поезда : '
        train_number = gets.chomp.to_i
      end
      if trains[train_number - 1].type == 'passenger'
        trains[train_number - 1].add_car(PassengerCar.new)
      else
        trains[train_number - 1].add_car(CargoCar.new)
      end
      puts "К поезду #{trains[train_number - 1].number} успешно добавлен вагон" 
    end
  when 6
    puts 'Отцепить вагоны от поезда'
    puts ''
    if trains == []
      puts 'Поездов еще нет'
    else
      puts 'Список поездов : '
      i = 0
      trains.each do |x| 
        i += 1
        puts "#{i} - #{x.number}"
      end
      train_number = nil
      while !(1..i).include?(train_number)
        puts 'Введите номер нужного поезда : '
        train_number = gets.chomp.to_i
      end
      if trains[train_number - 1].cars == []
        puts 'У поезда нет вагонов!'
      else
        trains[train_number - 1].remove_car(trains[train_number - 1].cars[-1])
      end
    end
  when 7
    puts 'Переместить поезд по маршруту вперед и назад'
    puts ''
    if trains == []
      puts 'Поездов нет'
    else
      puts 'Список поездов : '
      i = 0
      trains.each do |x|
        i += 1
        puts "#{i} - #{x.number}"
      end
      train_number = nil
      while !(1..i).include?(train_number)
        puts 'Введите номер поезда : '
        train_number = gets.chomp.to_i
      end
      if trains[train_number - 1].have_a_route?
        trains[train_number - 1].closest_stations
        direction = nil
        while direction != 'вперед' && direction != 'назад'
          puts 'Введите в какую сторону по маршруту отправить поезд? (вперед/назад)'
          direction = gets.chomp
        end
        if direction == 'вперед'
          trains[train_number - 1].move_forward
        else
          trains[train_number - 1].move_back
        end
      else
        puts 'Этому поезду еще не назначен маршрут!'
      end
    end
  when 8
    stations.each do |station|
      puts "Станция #{station.name}"
      station.show_trains
      puts " "
    end
  when 9
    puts 'Выходим..'
  else
    puts 'Введите подходящую цифру!'
  end
end