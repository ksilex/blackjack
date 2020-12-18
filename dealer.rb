require_relative 'hand_info'

class Dealer
  include HandInfo
  attr_accessor :hand, :bank, :bet

  def initialize
    @bank = 100
    @bet = 10
  end

  def need_cards?
    count_sum < 17
  end
end
