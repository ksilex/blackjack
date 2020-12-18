require_relative 'hand_info'

class Player
  include HandInfo
  attr_accessor :hand, :bank, :bet

  def initialize(name)
    @bank = 100
    @name = name
    @bet = 10
  end
end
