require_relative 'player'
require_relative 'dealer'

class Game
  DECK = { '2+' => 2, '2<3' => 2, '2^' => 2, '2<>' => 2, '3+' => 3, '3<3' => 3, '3^' => 3, '3<>' => 3,
           '4+' => 4, '4<3' => 4, '4^' => 4, '4<>' => 4, '5+' => 5, '5<3' => 5, '5^' => 5, '5<>' => 5,
           '6+' => 6, '6<3' => 6, '6^' => 6, '6<>' => 6, '7+' => 7, '7<3' => 7, '7^' => 7, '7<>' => 7,
           '8+' => 8, '8<3' => 8, '8^' => 8, '8<>' => 8, '9+' => 9, '9<3' => 9, '9^' => 9, '9<>' => 9,
           '10+' => 10, '10<3' => 10, '10^' => 10, '10<>' => 10, 'K+' => 10, 'K<3' => 10, 'K^' => 10, 'K<>' => 10,
           'Q+' => 10, 'Q<3' => 10, 'Q^' => 10, 'Q<>' => 10, 'J+' => 10, 'J<3' => 10, 'J^' => 10, 'J<>' => 10,
           'A+' => 11, 'A<3' => 11, 'A^' => 11, 'A<>' => 11 }.freeze

  attr_reader :deck, :player, :dealer

  def initialize
  end

  def create_player
    puts 'Введите свое имя'
    name = gets.chomp
    @player = Player.new(name)
  end

  def start_game
    refresh_deck
    @dealer = Dealer.new
    player.player_hand = deck.to_a.sample(2).to_h
    deck.reject! { |key| player.player_hand.include?(key) }
    puts "Ваши карты: #{player.player_hand.keys.join(', ')},"
    dealer.dealer_hand = deck.to_a.sample(2).to_h
    deck.reject! { |key| dealer.dealer_hand.include?(key) }
    puts "#{player.player_hand.keys.count} карта(ы) у дилера"
    player.bank -= 10
    dealer.bank -= 10
    game_bank = 20
    count_sum
  end

  def add_card
    player.player_hand.merge!(deck.to_a.sample(1).to_h)
    deck.reject! { |key| player.player_hand.include?(key) }
    puts "Ваши карты: #{player.player_hand.keys.join(', ')},"
    count_sum
  end

  def count_sum
    sum = player.player_hand.values.sum
    if (player.hand_with_ace?) && (sum > 21)
      aces = player.player_hand.select { |key, val| val == 11 }
      aces = aces.keys.map(&:to_s)
      aces.each { |ace| player.player_hand[ace] = 1 }
      sum = player.player_hand.values.sum
    end
    sum
  end

  private

  def refresh_deck
    @deck = DECK.dup
  end
end

#puts "Карты дилера: #{player.player_hand.keys.map{|key| key = "*"}.join(', ')}"