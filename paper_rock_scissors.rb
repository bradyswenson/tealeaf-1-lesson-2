#OO PRS

class Hand
  include Comparable

  attr_reader :value

  def initialize(v)
    @value = v
  end

  def <=>(other_hand)
    if @value == other_hand.value
      0
    elsif @value == 'p' && other_hand.value == 'r' 
      1
    elsif @value == 'r' && other_hand.value == 's'
      1
    elsif @value == 's' && other_hand.value == 'p'
      1
    else
      -1
    end
  end

  def winning_message
    case @value
    when 'p'
      puts "Paper wraps rock!"
    when 'r'
      puts "Rock smashes scissors!"
    when 's'
      puts 'Scissors cut paper!'
    end
  end 
end

class Player
  attr_accessor :hand
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def selected_value
    "#{name} chose #{Game::CHOICES[self.hand.value]}"
  end
end

class Human < Player
  def pick_hand   
    begin
      puts "#{name}, please pick paper, rock or scissors (p/r/s):"
      c = gets.chomp.downcase
    end until Game::CHOICES.keys.include?(c)

    self.hand = Hand.new(c)
  end 
end

class Computer < Player
  def pick_hand
    self.hand = Hand.new(Game::CHOICES.keys.sample)
  end
end

class Game
  CHOICES = {'p' => 'Paper', 'r' => 'Rock', 's' => 'Scissors'}
  attr_reader :player, :computer

  def compare_hands
    if player.hand == computer.hand
      puts "Tie!"
    elsif player.hand > computer.hand
      player.hand.winning_message
      puts "#{player.name} wins!"
    else
      computer.hand.winning_message
      puts "#{computer.name} wins!"
    end
  end

  def play
    system 'clear'
    puts "Welcome to Paper Rock Scissors."
    puts "What's your name?"
    name = gets.chomp
    @player = Human.new(name)
    
    computer_names = ['Hal', 'R2D2', 'Data', 'C3PO', 'Watson']
    @computer = Computer.new(computer_names.sample)

    puts "Your computer opponent is #{computer.name}."
    puts "Here we go..."
    sleep (2.5)   

    begin
      system 'clear'
      player.pick_hand
      computer.pick_hand
      puts player.selected_value
      puts computer.selected_value
      compare_hands
      puts "Do you want to play again? (y/n)"
      continue = gets.chomp
    end while continue.downcase == 'y'

  end
end

Game.new.play
  