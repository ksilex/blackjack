module InitialHands
  ACES = { 'A+' => 11, 'A<3' => 11, 'A^' => 11, 'A<>' => 11 }.freeze

  def aces
    @aces = ACES
  end

  def init_hand(person)
    person.hand = deck.to_a.sample(2).to_h
    deck.reject! { |key| person.hand.include?(key) }
  end

  def add_card(person)
    return if person.hand.size > 2
    person.hand.merge!(deck.to_a.sample(1).to_h)
    deck.reject! { |key| person.hand.include?(key) }
    person.count_sum
  end

  def count_sum
    sum = hand.values.sum
    if hand_with_ace? && sum > 21
      aces = hand.select { |key, val| val == 11 }
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