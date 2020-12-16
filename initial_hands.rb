module InitialHands
  def init_hand(person)
    person.hand = deck.to_a.sample(2).to_h
    deck.reject! { |key| person.hand.include?(key) }
  end
end