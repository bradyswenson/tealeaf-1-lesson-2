#Blackjack object oriented

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
  end

  def print
    cards.each do |card|
      puts card.suit
      puts card.value
    end
  end

  def scramble!
    cards.shuffle!
  end

  def deal
    cards.shift
  end
end

class Player

end

class Dealer

end

class Blackjack
  attr_accessor :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new

  end

  def play
    deck.scramble!
    deck.print
    # deal_cards
    # show_flow
    # player_turn
    # dealer_turn
    # who_won?
  end

end

Blackjack.new.play
