require_relative 'company_name'
require_relative 'instance_counter'
require_relative 'valid_checker'
require_relative 'accessors'

class Train
  include CompanyName
  include InstanceCounter
  include ValidChecker
  extend Accessors

  NUMBER_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i.freeze

  attr_reader :number, :type, :wagons, :current_station, :route
  attr_accessor_with_history :speed
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    @@trains[number] = self
    register_instance
    validate!
  end

  def stop
    self.speed = 0
  end

  def add_wagon
    return 'Остановите поезд' unless speed.zero?

    if type == 'passenger'
      puts 'Введите кол-во мест'
      seats = gets.chomp.to_i
      wagons.push(PassengerWagon.new(seats))
    else
      puts 'Введите объем'
      volume = gets.chomp.to_f
      wagons.push(CargoWagon.new(volume))
    end
    puts "Кол-во вагонов: #{@wagons.count}"
  end

  def delete_wagon
    if speed.zero?
      @wagons.pop
    else
      puts 'Остановите поезд'
    end
    puts "Кол-во вагонов: #{@wagons.count}"
  end

  def assign_route(route)
    @route = route
    @current_station = route.stations.first
    @current_station.add_train(self)
  end

  def move_forward
    return unless next_station

    @current_station.train_leave(self)
    @current_station = next_station
    @current_station.add_train(self)
  end

  def move_back
    return unless prev_station

    @current_station.train_leave(self)
    @current_station = prev_station
    @current_station.add_train(self)
  end

  def next_station
    route.stations[current_station_id + 1]
  end

  def prev_station
    route.stations[current_station_id - 1] if current_station_id != 0
  end

  def add_block_to_wagons(&block)
    @wagons.map(&block)
  end

  protected

  def current_station_id
    route.stations.index(@current_station)
  end
end
