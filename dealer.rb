require_relative 'initial_hands'

class Dealer
  include InitialHands
  attr_accessor :hand, :bank

  def initialize
    @bank = 100
  end

  def need_cards?
    count_sum < 17
  end
end