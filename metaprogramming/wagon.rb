require_relative 'company_name'
require_relative 'id_for_wagon'

class Wagon
  include IDIncrementor
  include CompanyName
  attr_reader :type

  def initialize(seats_or_volume)
    @seats_or_volume = seats_or_volume
    id_incrementor
    seats_or_volume_initial
  end

  protected

  def seats_or_volume_initial
    @seats_or_volume_initial = @seats_or_volume
  end
end
