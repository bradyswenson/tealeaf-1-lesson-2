# Tic Tac Toe OO

require 'pry'

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

  def check_winner(board_status)
    winner = nil
    Board::WINNING_COMBOS.each do |combo|
      winner = 'Player'   if board_status.values_at(*combo).count('X') == 3
      winner = 'Computer' if board_status.values_at(*combo).count('O') == 3
      winner = 'Tie'      if remaining_options == []
    end
    return winner
  end

  def remaining_options
    status.keys.select {|position| status[position] == ' '}
  end
end

class Player
  attr_accessor :name

  def initialize(name = nil)
    @name = name if name
  end
end

class Computer < Player
  def make_move(board_status, remaining_options)
    move = nil
    Board::WINNING_COMBOS.each do |combo|

      if board_status.values_at(*combo).count('O') == 2
        if board_status[combo[0]] == ' '
          move = combo[0]
        elsif board_status[combo[1]] == ' '
          move = combo[1]
        elsif board_status[combo[2]] == ' '
          move = combo[2]
        end 
      
      elsif move == nil && board_status.values_at(*combo).count('X') == 2
        if board_status[combo[0]] == ' '
          move = combo[0]
        elsif board_status[combo[1]] == ' '
          move = combo[1]
        elsif board_status[combo[2]] == ' '
          move = combo[2]
        end
      end
    end
    
    if move == nil && board_status[5] == ' '
      move = 5
    elsif move == nil
       move = remaining_options.sample
    end

    return move
  end  
end

class Human < Player
  def make_move(remaining_options)
    begin 
      puts "Please choose an unfilled position (1-9) to place your X:"
      player_choice = gets.chomp.to_i
    end until remaining_options.include?(player_choice)
    return player_choice
  end
end

class Game
  attr_reader :player, :computer, :board, :score
  
  def initialize
    @player = Human.new
    @computer = Computer.new
    @board = ''
    @score = {player: 0, computer: 0, tie: 0}
  end 

  def update_score(winner)
    case winner
    when 'Player'
      score[:player] += 1
    when 'Computer'
      score[:computer] += 1
    when 'Tie'
      score[:tie] += 1
    end
  end 

  def result_message(winner)
    case winner
    when 'Player'
      return "#{player.name} wins!"
    when 'Computer'
      return "#{computer.name} wins!"
    when 'Tie'
      return "It's a tie!"
    end
  end

  def play
    system 'clear'
    puts "Welcome to Tic Tac Toe."
    puts "What's your name?"
    name = gets.chomp
    player.name = name    
    
    computer_names = ['Hal', 'R2D2', 'Data', 'C3PO', 'Watson']
    computer.name = computer_names.sample

    puts "Your computer opponent is #{computer.name}."
    puts "Here we go..."
    sleep (2.5) 

    begin #continue loop
      board = Board.new
      
      begin #game loop
        board.draw
        
        board.status[player.make_move(board.remaining_options)] = 'X'
        board.draw
        
        winner = board.check_winner(board.status)

        board.status[computer.make_move(board.status, board.remaining_options)] = 'O' if winner == nil
        board.draw
        
        winner = board.check_winner(board.status)
      end while winner == nil

      update_score(winner)
      puts result_message(winner)
      puts "Player: #{score[:player]} -- Computer: #{score[:computer]} -- Ties: #{score[:tie]}"
      
      puts "Do you want to play again? (y/n)"
      continue = gets.chomp
    end while continue.downcase == 'y'
  end 
end

Game.new.play