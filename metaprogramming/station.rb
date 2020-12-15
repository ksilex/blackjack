require_relative 'instance_counter'
require_relative 'valid_checker'

class Station
  include InstanceCounter
  include ValidChecker

  attr_reader :trains, :name
  validate :name, :presence
  validate :name, :format, /[a-zа-я]/i
  validate :name, :type, String

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations.push(self)
    register_instance
    validate!
  end

  def add_train(train)
    trains.push(train)
  end

  def trains_count_by_type(type)
    puts "Кол-во поездов по типу #{type}: #{trains.count { |train| train.type == type }}"
  end

  def trains_list
    trains.each do |train|
      puts "Номер: #{train.number}, Тип: #{train.type}, Кол-во вагонов: #{train.wagons.count}"
      puts 'Вагоны:'
      train.wagons.each do |wagon|
        print "Номер: #{wagon.wagon_id}, "
        if wagon.type == 'passenger'
          print "Занято мест: #{wagon.taken_seats}, Свободно: #{wagon.free_seats}"
        else
          print "Занят на: #{wagon.taken_volume} м(3), Свободно: #{wagon.left_volume} м(3)"
        end
        print "\n"
      end
    end
  end

  def train_leave(train)
    @trains.delete(train)
  end

  def add_block_to_trains(&block)
    @trains.map(&block)
  end
end
