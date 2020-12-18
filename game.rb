require_relative 'player'
require_relative 'dealer'
require_relative 'hand_manipulations'

class Game
  include HandManipulations
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
    puts 'Введите свое имя'
    name = gets.chomp
    @player = Player.new(name)
    @dealer = Dealer.new
    start_game
  end

  def start_game_callback
    if player.bank.zero?
      puts 'Вы банкрот'
      start_new_game
    elsif dealer.bank.zero?
      puts 'Вы обанкротили дилера, он не может продолжить игру...'
      start_new_game
    else
      start_game
    end
  end

  def player_give_card
    if add_card(player)
      player_hand
    else
      puts 'У вас в руке уже 3 карты'
    end
    dealers_turn
  end

  def dealers_turn
    if dealer.need_cards?
      add_card(dealer)
      puts "#{dealer.hand.keys.count} карта(ы) у дилера"
    else
      puts 'Дилер пропускает ход'
    end
    show_cards
  end

  def players_choice
    if cards_max? || someone_busted?
      show_cards
    else
      puts "1. Пропустить ход
            2. Добавить карту
            3. Открыть карты
            Введите действие:"
      choice = gets.chomp
      send ACTIONS[choice]
    end
  end

  def show_cards
    puts "\nРезультат\n\n"
    player_hand
    puts "Дилер: #{dealer.hand.keys.join(', ')}, очков: #{dealer.count_sum}"
    if someone_busted?
      result_if_busted
    elsif dealer.count_sum == player.count_sum
      puts 'Ничья'
      draw
    elsif dealer.count_sum < player.count_sum
      puts 'Вы выиграли'
      player_won
    else
      puts 'Вы проиграли'
      dealer_won
    end
    puts "Ваш банк: #{player.bank}"
    puts 'Нажмите 1 для новой раздачи'
    new_hand = gets.chomp.to_i
    start_game_callback if new_hand == 1
  end

  private

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

  def player_hand
    puts "Ваши карты: #{player.hand.keys.join(', ')}, очков: #{player.count_sum}"
  end

  def refresh_deck
    @deck = DECK.dup
  end

  def result_if_busted
    if dealer.busted? && player.busted?
      puts 'Вы проиграли'
      dealer_won
    elsif player.busted?
      puts 'Вы проиграли'
      dealer_won
    elsif dealer.busted?
      puts 'Вы выиграли'
      player_won
    end
  end

  def start_new_game
    puts 'Начать новую игру? Нажмите Enter'
    enter = gets
    start_game if enter == "\n"
  end

  def start_game
    refresh_deck
    init_hand(player)
    player_hand
    init_hand(dealer)
    puts "#{dealer.hand.keys.count} карты у дилера"
    player.bank -= player.bet
    dealer.bank -= player.bet
    self.game_bank = player.bet + dealer.bet
    players_choice
  end

  def player_won
    player.bank += game_bank
  end

  def dealer_won
    dealer.bank += game_bank
  end

  def draw
    dealer.bank += game_bank / 2
    player.bank += game_bank / 2
  end
end
