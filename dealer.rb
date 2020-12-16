class Dealer
  attr_accessor :hand, :bank

  def initialize
    @bank = 100
  end

  def need_cards?
    sum < 17
  end
end