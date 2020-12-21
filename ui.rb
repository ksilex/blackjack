module UI
  def self.ask_name
    puts 'Введите свое имя'
  end

  def self.bankrupt(person)
    if person.instance_of?(Player)
      puts 'Вы банкрот!'
    else
      puts 'Вы обанкротили дилера, он не может продолжить игру...'
    end
  end

  def self.player_hand(cards, points)
    puts "Ваши карты: #{cards.join(', ')}, очков: #{points}"
  end

  def self.player_hand_full
    puts 'У вас в руке уже 3 карты'
  end

  def self.dealer_hand_count(count)
    puts "#{count} карта(ы) у дилера"
  end

  def self.dealer_pass
    puts 'Дилер пропускает ход'
  end

  def self.player_options
    puts "\n
    1. Пропустить ход\n
    2. Добавить карту\n
    3. Открыть карты\n
    Введите действие:"
  end

  def self.result_if_busted(dealer, player, game_bank)
    if dealer.busted? && player.busted?
      dealer_won(dealer, game_bank)
    elsif player.busted?
      dealer_won(player, game_bank)
    elsif dealer.busted?
      player_won(player, game_bank)
    end
  end

  def self.player_won(player, game_bank)
    puts 'Вы выиграли'
    player.bank += game_bank
  end

  def self.dealer_won(dealer, game_bank)
    puts 'Вы проиграли'
    dealer.bank += game_bank
  end

  def self.draw(player, dealer, game_bank)
    puts 'Ничья'
    dealer.bank += game_bank / 2
    player.bank += game_bank / 2
  end

  def self.dealer_hand(dealer_cards, count)
    puts "Дилер: #{dealer_cards.join(', ')}, очков: #{count}"
  end

  def self.show_bank(player)
    puts "Ваш банк: #{player.bank}"
    puts 'Нажмите 1 для новой раздачи'
  end

  def result_msg
    puts "\nРезультат\n\n"
  end

  def new_game_msg
    puts 'Начать новую игру? Нажмите Enter'
  end
end
