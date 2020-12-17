require_relative 'player'
require_relative 'dealer'
require_relative 'initial_hands'

class Game
  include InitialHands
  DECK = { '2+' => 2, '2<3' => 2, '2^' => 2, '2<>' => 2, '3+' => 3, '3<3' => 3, '3^' => 3, '3<>' => 3,
           '4+' => 4, '4<3' => 4, '4^' => 4, '4<>' => 4, '5+' => 5, '5<3' => 5, '5^' => 5, '5<>' => 5,
           '6+' => 6, '6<3' => 6, '6^' => 6, '6<>' => 6, '7+' => 7, '7<3' => 7, '7^' => 7, '7<>' => 7,
           '8+' => 8, '8<3' => 8, '8^' => 8, '8<>' => 8, '9+' => 9, '9<3' => 9, '9^' => 9, '9<>' => 9,
           '10+' => 10, '10<3' => 10, '10^' => 10, '10<>' => 10, 'K+' => 10, 'K<3' => 10, 'K^' => 10, 'K<>' => 10,
           'Q+' => 10, 'Q<3' => 10, 'Q^' => 10, 'Q<>' => 10, 'J+' => 10, 'J<3' => 10, 'J^' => 10, 'J<>' => 10,
           'A+' => 11, 'A<3' => 11, 'A^' => 11, 'A<>' => 11 }.freeze
  ACTIONS = { '1' => :dealers_turn, '2' => :player_give_card, '3' => :show_cards}.freeze

  attr_reader :deck, :player, :dealer, :game_bank

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
    init_hand(player)
    player_hand
    init_hand(dealer)
    puts "#{dealer.hand.keys.count} карты у дилера"
    player.bank -= player.bet
    dealer.bank -= player.bet
    @game_bank = player.bet * 2
    players_choice
  end

  def player_give_card
    if !game_finished
      add_card(player)
      dealers_turn
    else 
      game_finished
    end
  end

  def dealers_turn
    if dealer.need_cards?
      add_card(dealer)
      puts "#{dealer.hand.keys.count} карта(ы) у дилера"
      game_finished
    else
      game_finished
    end
  end

  def players_choice
      puts "1. Пропустить ход
            2. Добавить карту
            3. Открыть карты
            Введите действие:"
      choice = gets.chomp
      send ACTIONS[choice]
  end

  def show_cards
    player_hand
    puts "Дилер: #{dealer.hand.keys.join(', ')}, очков: #{dealer.count_sum}"
    if dealer.count_sum == player.count_sum 
      puts "Ничья"
    else
      puts dealer.count_sum < player.count_sum ? 'Вы выиграли' : 'Вы проиграли'
    end
  end

  private

  def game_finished
    if player.busted? && dealer.busted?
      puts 'Вы проиграли'
      player_hand
      puts "Дилер: #{dealer.hand.keys.join(', ')}, очков: #{dealer.count_sum}"
    elsif player.busted?
      puts 'Вы проиграли'
      player_hand
      puts "Дилер: #{dealer.hand.keys.join(', ')}, очков: #{dealer.count_sum}"
    elsif dealer.busted?
      puts 'Вы выиграли'
      player_hand
      puts "Дилер: #{dealer.hand.keys.join(', ')}, очков: #{dealer.count_sum}"
    else
      can_add_more_cards?
    end
  end

  def can_add_more_cards?
    if !dealer.need_cards? && player.hand.size == 3
      player_hand
      puts "Дилер: #{dealer.hand.keys.join(', ')}, очков: #{dealer.count_sum}"
      puts dealer.count_sum < player.count_sum ? 'Вы выиграли' : 'Вы проиграли'
    else
      show_cards
      false
    end
  end

  def player_hand
    puts "Ваши карты: #{player.hand.keys.join(', ')}, очков: #{player.count_sum}"
  end
  def refresh_deck
    @deck = DECK.dup
  end
end
