class CargoWagon < Wagon
  def initialize(seats_or_volume)
    @type = 'cargo'
    super
  end

  def wagon_load(volume)
    @seats_or_volume -= volume
  end

  def taken_volume
    @seats_or_volume_initial - @seats_or_volume
  end

  def left_volume
    @seats_or_volume
  end
end
