#Blackjack object oriented

require 'pry'

class Card
  attr_accessor :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "#{value}#{suit}"
  end
end

class Deck
  attr_accessor :cards

  def initialize()
    @cards = []
    ['♠', "\e[31m♥\e[0m", "\e[31m♦\e[0m", '♣'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    cards.shuffle!
  end

  def deal_one
    cards.shift
  end

  def size
    cards.size
  end
end

module Hand

  def add_card(new_card)
    cards << new_card
  end

  def draw_hand(hide_dealer_card = false)
  line1 = ""
  line2 = ""
  line3 = ""
  line4 = ""
  cards.each_with_index do |card, index| 
    if (index == 0 && hide_dealer_card)
      line1 << "┌───┐ "
      line2 << "│ * │ "
      line3 << "│ * │ "
      line4 << "└───┘ " 
      next   
    end
    if card.value.length == 1
      line1 << "┌───┐ "
      line2 << "│ #{card.value} │ "
      line3 << "│ #{card.suit} │ "
      line4 << "└───┘ "
    elsif card.value.length == 2
      line1 << "┌───┐ "
      line2 << "│ #{card.value}│ "
      line3 << "│ #{card.suit} │ "
      line4 << "└───┘ "
    end  
  end
  puts line1
  puts line2
  puts line3
  puts line4
  end

  def hand_total(hide_dealer_card = false)
    values = cards.map{|card| card.value }

    total = 0
    values.each_with_index do |value, index|
      next if (index == 0 && hide_dealer_card)
      if value == "A"
        total += 11
      else
        total += (value.to_i == 0 ? 10 : value.to_i)
      end
    end

    #correct for Aces
    values.select{|value| value == "A"}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end

  def blackjack?
    true if hand_total == 21 and cards.size == 2
  end

  def bust?
    true if hand_total > 21
  end

end

class Player
  include Hand

  attr_accessor :name, :cards, :money, :bet

  def initialize(name)
    @name = name
    @cards = []
    @money = 1000
    @bet = 0
  end

  def turn

  end

  def make_bet
    begin
    puts "You have $#{money}. How much do you want to bet (1-#{money})?"
    get_bet = gets.chomp.to_i
    end until get_bet.between?(1, money)
    self.bet = get_bet
  end


end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end

  def turn
  end

end



class Blackjack
  attr_accessor :player, :dealer, :deck

  def initialize
    @player = Player.new("Brady")
    @dealer = Dealer.new
    @deck = Deck.new

  end

  def draw_table(hide_dealer_card = true) 
    system 'clear'
    dealer.draw_hand(hide_dealer_card)
    player.draw_hand
    puts "You have #{player.hand_total}. Dealer #{hide_dealer_card ? 'showing' : 'has'} #{dealer.hand_total(hide_dealer_card)}."
    puts ""
  end

  def settle_bet

  end

  #make a check winner method to return player, dealer or tie and use that for end_message settle_bet
  def end_message
    if dealer.blackjack?
      message = "You lost. Better luck next hand #{player_name}."
    elsif  player.blackjack?
      message = "Blackjack! You win!"    
    elsif player.bust?
      message = "Sorry #{player_name}, you busted."
    elsif dealer.bust?
      message = "Dealer busted. You win!"
    elsif player.hand_total > dealer.hand_total
      message = "You win, #{player_name}!"
    elsif dealer.hand_total > player.hand_total
      message = "You lose."
    elsif player.hand_total == dealer.hand_total
      message = "Push."
    end
  end   

  def play
    deck = Deck.new

    player.make_bet

    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    
    draw_table(hide_dealer_card = true)

    
    if !player.blackjack? and !dealer.blackjack?
      begin

        begin 
          puts "Stay or Hit? (S/H)"
          choice = gets.chomp
        end until choice.downcase == 's' || choice.downcase == 'h'

        if choice == 'h'
          player.add_card(deck.deal_one)
          draw_table(hide_dealer_card = true)
        end

      end until choice == 's' || player.bust?

      if !player.bust?
        if dealer.hand_total < 17 #use ace total to make dealer stand on soft 17
          begin 
              dealer.add_card(deck.deal_one)
              draw_table(hide_dealer_card = false)
          end until dealer.hand_total >= 17 
        end
      end 

    end



    puts "#{end_message}" 



    # puts "Player blackjack!" if player.blackjack?
    # puts "Dealer blackjack!" if dealer.blackjack?
    # puts "Player bust!" if player.bust?
    # puts "Dealer bust!" if dealer.bust?

  end
end

Blackjack.new.play
