require_relative 'player'
require_relative 'dealer'
require_relative 'ui'

class Game
  include UI
  DECK = { '2+' => 2, '2<3' => 2, '2^' => 2, '2<>' => 2, '3+' => 3, '3<3' => 3, '3^' => 3,
           '3<>' => 3, '4+' => 4, '4<3' => 4, '4^' => 4, '4<>' => 4, '5+' => 5, '5<3' => 5,
           '5^' => 5, '5<>' => 5, '6+' => 6, '6<3' => 6, '6^' => 6, '6<>' => 6, '7+' => 7,
           '7<3' => 7, '7^' => 7, '7<>' => 7, '8+' => 8, '8<3' => 8, '8^' => 8, '8<>' => 8,
           '9+' => 9, '9<3' => 9, '9^' => 9, '9<>' => 9, '10+' => 10, '10<3' => 10, '10^' => 10,
           '10<>' => 10, 'K+' => 10, 'K<3' => 10, 'K^' => 10, 'K<>' => 10, 'Q+' => 10, 'Q<3' => 10,
           'Q^' => 10, 'Q<>' => 10, 'J+' => 10, 'J<3' => 10, 'J^' => 10, 'J<>' => 10, 'A+' => 11,
           'A<3' => 11, 'A^' => 11, 'A<>' => 11 }.freeze
  ACTIONS = { '1' => :dealers_turn, '2' => :player_give_card, '3' => :show_cards }.freeze

  attr_reader :deck, :player, :dealer
  attr_accessor :game_bank

  def initialize
    create_player
  end

  def create_player
    UI.ask_name
    name = gets.chomp
    @player = Player.new(name)
    @dealer = Dealer.new
    start_game
  end

  def start_game_callback
    if player.bank.zero? || dealer.bank.zero?
      UI.bankrupt(person)
      start_new_game
    else
      start_game
    end
  end

  def player_give_card
    if add_card(player)
      UI.player_hand(player.hand.keys, player.count_sum)
    else
      UI.player_hand_full
    end
    dealers_turn
  end

  def dealers_turn
    if dealer.need_cards?
      add_card(dealer)
      UI.dealer_hand_count(dealer.hand.keys.count)
    else
      UI.dealer_pass
    end
    show_cards
  end

  def players_choice
    if cards_max? || someone_busted?
      show_cards
    else
      UI.player_options
      choice = gets.chomp
      send ACTIONS[choice]
    end
  end

  def show_cards
    puts "\nРезультат\n\n"
    UI.player_hand(player.hand.keys, player.count_sum)
    UI.dealer_hand(dealer.hand.keys, dealer.count_sum)
    if someone_busted?
      UI.result_if_busted(dealer, player, game_bank)
    elsif dealer.count_sum == player.count_sum
      UI.draw(player, dealer, game_bank)
    elsif dealer.count_sum < player.count_sum
      UI.player_won(player, game_bank)
    else
      UI.dealer_won(dealer, game_bank)
    end
    UI.show_bank(player)
    new_hand = gets.chomp.to_i
    start_game_callback if new_hand == 1
  end

  private

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

  def cards_max?
    if (!dealer.need_cards? || dealer.hand.size == 3) && player.hand.size == 3
      true
    else
      false
    end
  end

  def someone_busted?
    player.busted? || dealer.busted?
  end

  def refresh_deck
    @deck = DECK.dup
  end

  def start_new_game
    puts 'Начать новую игру? Нажмите Enter'
    enter = gets
    start_game if enter == "\n"
  end

  def start_game
    refresh_deck
    init_hand(player)
    UI.player_hand(player.hand.keys, player.count_sum)
    init_hand(dealer)
    UI.dealer_hand_count(dealer.hand.keys.count)
    player.bank -= player.bet
    dealer.bank -= player.bet
    self.game_bank = player.bet + dealer.bet
    players_choice
  end
end
