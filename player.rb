class Player
  ACES = { 'A+' => 11, 'A<3' => 11, 'A^' => 11, 'A<>' => 11 }.freeze
  attr_accessor :hand, :aces, :bank

  def initialize(name)
    @bank = 100
    @name = name
    @aces = ACES
  end

  def hand_with_ace?
    (aces.keys & hand.keys).any?
  end
end
