module HandInfo
  ACES = { 'A+' => 11, 'A<3' => 11, 'A^' => 11, 'A<>' => 11}.freeze

  def aces
    @aces = ACES
  end

  def count_sum
    sum = hand.values.sum
    if hand_with_ace? && sum > 21
      aces = hand.select { |_key, val| val == 11 }
      aces = aces.keys.map(&:to_s)
      aces.each { |ace| hand[ace] = 1 }
      sum = hand.values.sum
    end
    sum
  end

  def hand_with_ace?
    (aces.keys & hand.keys).any?
  end

  def busted?
    count_sum > 21
  end
end
