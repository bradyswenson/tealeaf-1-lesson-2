# Tic Tac Toe OO

class Board
  WINNING_COMBOS = [[1,2,3], [1,5,9], [1,4,7], [2,5,8], [3,5,7], [4,5,6], [7,8,9], [3,6,9]] 

  attr_accessor :status

  def initialize 
    @status =  {1 => ' ', 2 =>  ' ', 3 => ' ', 4 => ' ', 5 => ' ', 6 => ' ', 7 => ' ', 8 => ' ', 9 => ' '}
  end

  def draw
  system 'clear'
  puts "
             |     |
          #{status[1]}  |  #{status[2]}  |  #{status[3]}  
        _____|_____|_____
             |     |
          #{status[4]}  |  #{status[5]}  |  #{status[6]}  
        _____|_____|_____
             |     |
          #{status[7]}  |  #{status[8]}  |  #{status[9]}
             |     |
  "
  end

  def check_winner

  end

  def remaining_options
    status.keys.select {|position| status[position] == ' '}
  end
end

class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class Computer < Player
  def make_move
    Board::WINNING_COMBOS.each do |combo|
    if Board::status[combo[0]] == 'O' and Board::status[combo[1]] == 'O' and Board::status[combo[2]] == ' '
        return combo[2]
    elsif Board::status[combo[1]] == 'O' and Board::status[combo[2]] == 'O' and Board::status[combo[0]] == ' '
        return combo[0]
    elsif Board::status[combo[0]] == 'O' and Board::status[combo[2]] == 'O' and Board::status[combo[1]] == ' '
        return combo[1]
    elsif Board::status[combo[0]] == 'X' and Board::status[combo[1]] == 'X' and Board::status[combo[2]] == ' '
        return combo[2]
    elsif Board::status[combo[1]] == 'X' and Board::status[combo[2]] == 'X' and Board::status[combo[0]] == ' '
        return combo[0]
    elsif Board::status[combo[0]] == 'X' and Board::status[combo[2]] == 'X' and Board::status[combo[1]] == ' '
        return combo[1]
    end
  end
  if Board::status[5] == ' '
    return 5
  else
    return Board.remaining_options(b).sample
  end
  end
end

class Human < Player
  def make_move
    begin 
      puts "Please choose an unfilled position (1-9) to place your X:"
      player_choice = gets.chomp.to_i
    end until remaining_options(board).include?(player_choice)
  end
end

class Game
  attr_reader :player, :computer, :board
  
  def initialize
    @score = {player: 0, computer: 0, tie: 0}
  end 

  def play
    # get player name, instantiate player
    # get computer name, instatiate computer
    #   continue loop
    #     game loop
    #       draw board
    #       get player choice
    #       check winner
    #       draw baord
    #       get computer choice
    #       check winner
    #     loop until winner
    #     ask if player wants to play again 
    #   loop while continue is yes
    
    @board = Board.new

    system 'clear'
    puts "Welcome to Tic Tac Toe."
    puts "What's your name?"
    name = gets.chomp
    @player = Human.new(name)    
    
    computer_names = ['Hal', 'R2D2', 'Data', 'C3PO', 'Watson']
    @computer = Computer.new(computer_names.sample)

    puts "Your computer opponent is #{computer.name}."
    puts "Here we go..."
    sleep (2.5) 

    board.draw


  end 
end

game = Game.new.play