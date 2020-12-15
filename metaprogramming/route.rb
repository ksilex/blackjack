require_relative 'instance_counter'
require_relative 'valid_checker'

class Route
  include InstanceCounter
  include ValidChecker

  attr_reader :stations
  validate :stations, :endpoints
  validate :stations, :endpoints_differ

  def initialize(origin, destination)
    @stations = [origin, destination]
    @origin = origin
    @destination = destination
    register_instance
    validate!
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def delete_station(station)
    stations.delete(station) unless [stations.first, stations.last].include?(station)
  end

  def list_stations
    puts 'Станции маршрута: '
    stations.each { |station| puts station.name.to_s }
  end
end
