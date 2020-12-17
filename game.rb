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
    if add_card(player)
    player_hand
    else 
      puts "У вас в руке уже 3 карты"
    end
    dealers_turn
  end

  def dealers_turn
    if dealer.need_cards?
      add_card(dealer)
      puts "#{dealer.hand.keys.count} карта(ы) у дилера"
    else
      puts "Дилер пропускает ход"
    end
    show_cards
  end

  def players_choice
    if cards_max || someone_busted?
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
      puts "Ничья"
    else
      puts dealer.count_sum < player.count_sum ? 'Вы выиграли' : 'Вы проиграли'
    end
    puts "Нажмите 1 для новой раздачи"
    new_hand = gets.chomp.to_i
    self.start_game if new_hand == 1
  end

  private

  def cards_max
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
      puts "Вы проиграли"
    elsif player.busted?
      puts "Вы проиграли"
    elsif dealer.busted?
      puts "Вы выиграли"
    end
  end
end
