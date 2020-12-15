class PassengerWagon < Wagon
  def initialize(seats_or_volume)
    @type = 'passenger'
    super
  end

  def take_seat
    @seats_or_volume -= 1
  end

  def taken_seats
    @seats_or_volume_initial - @seats_or_volume
  end

  def free_seats
    @seats_or_volume
  end
end
