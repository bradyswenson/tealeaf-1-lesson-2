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
    ['♠', '♥', '♦', '♣'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    cards.shuffle!
  end

  def print
    cards.each do |card|
      puts card.suit
      puts card.value
    end
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
      line2 << "│ ? │ "
      line3 << "│ ? │ "
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

end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end

end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end

end



class Blackjack
  attr_accessor :player, :dealer, :deck

  def initialize
    @player = Player.new("Brady")
    @dealer = Dealer.new
    @deck = Deck.new

  end

  def draw_table(final = false) 
    system 'clear'
    dealer.draw_hand(final)
    player.draw_hand
    puts "You have #{player.hand_total}. Dealer #{final ? 'has' : 'showing'} #{dealer.hand_total(final)}."
    puts ""
  end

  def play
    deck = Deck.new

    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    
    draw_table(final = true)
  end
end

Blackjack.new.play
