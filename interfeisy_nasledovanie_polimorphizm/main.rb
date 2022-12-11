# Для запуска в irb : 
# irb -r ./main.rb
# a = Main.new
# a.start

require './route.rb'
require './train.rb'
require './car.rb'
require './cargo_car.rb'
require './cargo_train.rb'
require './passenger_car.rb'
require './passenger_train.rb'
require './station.rb'

class Main

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  MENU = [
    {index: 1, title: "Создать станцию", action: :create_station},
    {index: 2, title: "Содать поезд", action: :create_train},
    {index: 3, title: "Создать маршрут и управлять станциями в нем", action: :create_edit_route},
    {index: 4, title: "Назначить маршрут поезду", action: :set_route},
    {index: 5, title: "Добавить вагоны к поезду", action: :add_car},
    {index: 6, title: "Отцепить вагоны от поезда", action: :remove_car},
    {index: 7, title: "Переместить поезд по маршруту", action: :move_train},
    {index: 8, title: "Просмотреть список станций и поездов", action: :show_stations_and_trains}
  ].freeze

  # работа с классом идет только через этот метод, остальные приватные
  def start
    loop do
      MENU.each {|x| puts "#{x[:index]} - #{x[:title]}"}
      print 'Ввод : '
      user_input = gets.chomp.to_i
      need_item = MENU.find {|x| x[:index] == user_input}
      send(need_item[:action])
      puts 'Нажмите любую кнопку или введите выход, чтобы закончить'
      break if gets.chomp == 'выход'
    end
  end

  private

  def create_station
    print 'Введите название станции (уникальное): '
    @station_name = gets.chomp
    @stations << Station.new(@station_name)
    puts "Станция #{@station_name} успешно добавлена!"
  end

  def create_train
    print 'Введите название поезда (уникальное): '
    @train_name = gets.chomp
    print 'Введите тип поезда (грузовой / пассажирский) : '
    @train_type = gets.chomp
    if @train_type == 'грузовой'
      @trains << CargoTrain.new(@train_name)
      puts "Добавлен #{@train_type} поезд #{@train_name}"
    elsif @train_type == 'пассажирский'
      @trains << PassengerTrain.new(@train_name)
      puts "Добавлен #{@train_type} поезд #{@train_name}"
    else
      puts 'Ошибка!'
    end
  end

  def create_edit_route
    puts 'Создать маршрут или управлять станциями в нем? (создать/управлять)'
    @user_select = gets.chomp
    if @user_select == 'управлять'
      if @routes == []
        puts 'Маршрутов еще нет'
      else
        puts 'Список маршрутов : '
        @i = 0
        @routes.each do |x|
          @i += 1
          puts "Маршрут №#{@i} : "
          x.show_route
        end
        puts 'Введите номер маршрута для изменения : '
        @route_number = gets.chomp.to_i
        puts 'Cтанции маршрута : '
        @routes[@route_number - 1].show_route
        puts 'Добавить или удалить станции из маршрута? (добавить/удалить)'
        @user_select = gets.chomp
        if @user_select == 'добавить'
          puts 'Список станций : '
          @i = 0
          @stations.each do |x|
            @i += 1
            puts "#{@i} - #{x.name}"
          end
          puts 'Введите номер станции, которую нужно добавить (уникальную) : '
          @station_number = gets.chomp.to_i
          @routes[@route_number - 1].between_station_add(@stations[@station_number - 1])
        elsif @user_select == 'удалить' && @routes[@route_number - 1].stations_list.length <= 2
          puts 'Маршрут слишком короткий, чтобы из него что-то удалять!'
        elsif @user_select == 'удалить' && @routes[@route_number - 1].stations_list.length > 2
          puts 'Список станций : '
          @i = 0
          @stations.each do |x|
            @i += 1
            puts "#{@i} - #{x.name}"
          end
          puts 'Введите номер станции, которую нужно удалить (которая есть в маршруте) : '
          @station_number = gets.chomp.to_i
          @routes[@route_number - 1].between_station_remove(@stations[@station_number - 1])
        else
          puts 'Ошибка!'
        end
      end
    elsif @user_select == 'создать'
      if @stations.length >= 2
        puts 'Создаем маршрут'
        puts ''
        @i = 0
        puts 'Список станций : '
        @stations.each do |x|
          @i += 1
          puts "#{@i} - #{x.name}"
        end
        puts 'Введите номер начальной станции : '
        @first_station = gets.chomp.to_i
        @i = 0
        puts 'Список станций : '
        @stations.each do |x|
          @i += 1
          puts "#{@i} - #{x.name}"
        end
        puts 'Введите номер конечной станции станции : '
        @last_station = gets.chomp.to_i
        @new_route = Route.new(@stations[@first_station - 1], @stations[@last_station - 1])
        puts 'Создан маршрут : '
        @new_route.show_route
        @routes << @new_route
      else
        puts 'Станций слишком мало, чтобы создать маршрут'
      end
    else
      puts 'Ошибка!'
    end
  end

  def set_route
    if @trains == [] || @routes == []
      puts 'Нету поездов или / и маршрутов'
    else
      puts 'Список поездов : '
      @i = 0
      @trains.each do |x|
        @i += 1
        puts "#{@i} - #{x.number}"
      end
      puts 'Введите номер поезда : '
      @train_number = gets.chomp.to_i
      puts 'Список маршрутов : '
      @i = 0
      @routes.each do |x|
        @i += 1
        puts "Маршрут № #{@i} : "
        x.show_route
      end
      puts 'Введите номер маршрута : '
      @route_number = gets.chomp.to_i
      puts "Назначем поезду #{@trains[@train_number - 1].number} следующий маршрут : "
      @routes[@route_number - 1].show_route
      puts ''
      @trains[@train_number - 1].set_route(@routes[@route_number - 1])
    end
  end

  def add_car
    if @trains == []
      puts 'Поездов еще нет'
    else
      puts 'Список поездов : '
      @i = 0
      @trains.each do |x| 
        @i += 1
        puts "#{@i} - #{x.number}"
      end
      puts 'Введите номер нужного поезда : '
      @train_number = gets.chomp.to_i
      if @trains[@train_number - 1].type == 'Passenger'
        @trains[@train_number - 1].add_car(PassengerCar.new)
      else
        @trains[@train_number - 1].add_car(CargoCar.new)
      end
      puts "К поезду #{@trains[@train_number - 1].number} успешно добавлен вагон" 
    end
  end

  def remove_car
    if @trains == []
      puts 'Поездов еще нет'
    else
      puts 'Список поездов : '
      @i = 0
      @trains.each do |x| 
        @i += 1
        puts "#{@i} - #{x.number}"
      end
      puts 'Введите номер нужного поезда : '
      @train_number = gets.chomp.to_i
      if @trains[@train_number - 1].cars == []
        puts 'У поезда нет вагонов!'
      else
        @trains[@train_number - 1].remove_car(@trains[@train_number - 1].cars[-1])
        puts 
      end
    end
  end

  def move_train
    if @trains == []
      puts 'Поездов нет'
    else
      puts 'Список поездов : '
      @i = 0
      @trains.each do |x|
        @i += 1
        puts "#{@i} - #{x.number}"
      end
      puts 'Введите номер поезда : '
      @train_number = gets.chomp.to_i
      if @trains[@train_number - 1].have_a_route?
        @trains[@train_number - 1].closest_stations
        puts 'Введите в какую сторону по маршруту отправить поезд? (вперед/назад)'
        @direction = gets.chomp
        if @direction == 'вперед'
          @trains[@train_number - 1].move_forward
        elsif @direction == 'назад'
          @trains[@train_number - 1].move_back
        else
          puts 'Ошибка!'
        end
      else
        puts 'Этому поезду еще не назначен маршрут!'
      end
    end
  end

  def show_stations_and_trains
    @stations.each do |station|
      puts "Станция #{station.name}"
      station.show_trains
      puts " "
    end
  end

end