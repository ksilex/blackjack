module HandManipulations
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
end
