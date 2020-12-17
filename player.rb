require_relative 'initial_hands'

class Player
  include InitialHands
  attr_accessor :hand, :bank, :bet

  def initialize(name)
    @bank = 100
    @name = name
    @bet = 10
  end
end
