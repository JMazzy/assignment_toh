#!/usr/bin/env ruby

# Procedural Tower of Hanoi Assignment

# Build a Ruby program that allows a player to play ToH from the command line, specifying the initial height of the tower.
# This will give you a chance to create an interactive command-line game. 

# What it should look like:
#
# Welcome to Tower of Hanoi!
# Instructions:
# Enter where you'd like to move from and to
# in the format [1,3]. Enter 'q' to quit.
# Current Board:
#   
#  (_)
# (___)
#(_____)
#TTTTTTTTTTTTTTTTTTTTTT
#   1      2      3
# Enter move >
# ...

# Rules: 
# 1. Only one disk can be moved at a time.
# 2. Each move consists of taking the upper disk from one of the stacks 
#    and placing it on top of another stack i.e. a disk can only be moved if it is the uppermost disk on a stack.
# 3. No disk may be placed on top of a smaller disk.

# 1. Wrap everything in a class 
# and focus on separating different functionality into methods instead of creating one long run-on game method.
# Tower of Hanoi Game Class
class ToH_Game
  # Game state (playing=0/win=1/quit=-1)
  @game_state = 0

  # Set up
  # Display welcome message and instructions.
  # Ask how big the player wants the tower to be
  def welcome
    puts "\n"
    puts "Welcome to Tower of Hanoi!"
    puts "Instructions:"
    puts "Enter where you'd like to move from and to"
    puts "in the format [1,3]. Enter q to quit."
    puts "\n"
  end

  def ask_tower_size
    # Max tower size
    min_tower_size = 3
    max_tower_size = 9

    puts "How big do you want your tower to be?"
    puts "(must be between #{min_tower_size} and #{max_tower_size})"
    puts "\n"

    tower_size = 0

    # Loop until a valid input is entered
    until tower_size >= min_tower_size and tower_size <= max_tower_size
      tower_size = gets.strip.to_i
      puts "\n"

      # Display a message if size is outside parameters
      if tower_size < min_tower_size
        puts "Enter something bigger!"
      elsif tower_size > max_tower_size
        puts "Enter something smaller!"
      end
    end

    # Return the valid value
    return tower_size
  end

  def tower_piece(piece_size, max_piece_size)
    pieces = [
      "        |        ", 
      "        O        ", 
      "       (O)       ", 
      "      (OOO)      ", 
      "     (OOOOO)     ", 
      "    (OOOOOOO)    ", 
      "   (OOOOOOOOO)   ", 
      "  (OOOOOOOOOOO)  ", 
      " (OOOOOOOOOOOOO) ", 
      "(OOOOOOOOOOOOOOO)", 
      "TTTTTTTTTTTTTTTTT"
    ]
    return pieces[piece_size]
  end

  # 4. Create a render method which prints out the current state of the game board in between turns. 
  # START SIMPLE! The render method usually gives people the most frustration. 
  # Start by just printing the game state in numeric form before you try to get creative with your output.
  # Render Method
  def render(current_game_board, tower_size)
    # Display text 
    puts "Current Board: "

    render_rows = ["","","","","","","","","","","",""]

    #Loop through
    0.upto(tower_size) do |row|
      0.upto(2) do |column|
        if current_game_board[column] == nil or current_game_board[column][row] == nil
          render_rows[row] << tower_piece(0,tower_size)
        else
          piece_size = current_game_board[column][row]
          render_rows[row] << tower_piece(piece_size,tower_size)
        end
      end
    end

    #Render in reverse order (top to bottom) so it appears correctly
    render_rows.reverse_each do |row|
      puts row
    end

    #Label line
    puts "[[[[[[[ 1 ]]]]]]][[[[[[[ 2 ]]]]]]][[[[[[[ 3 ]]]]]]]"

    # current_game_board.each do |column|
    #   column.each do |piece|
    #     if piece < 10
    #       print piece
    #     else
    #       print " "
    #     end
    #   end
    #   puts "\n"
    # end
    # puts "\n"

    # rows = Array.new(tower_size)

    # current_game_board.each do |column|
    #   blanks = tower_size - column.size
    #   column.each do |spot|


    #   end
    # end

    # Display number of rows corresponding to tower height
    # Display a column for each tower
    # Display a blank area for "nil" "tower spots"
    # Render tower pieces to show relative size


    # Display a row with column labels on it
  end

  # Method to handle moves
  def move(current_game_board, from_to)
    from = from_to[0] - 1
    to = from_to[1] - 1

    puts current_game_board[from].class
    # Check if the move is valid, if not do nothing but display a message
    if current_game_board[from].last < current_game_board[to].last
      # If valid, remove last item in the "from" column
      # place it in the "to" column (at the end) (array pop and push ?)
      current_game_board[to].push(current_game_board[from].pop)
      puts "Moved a piece from #{from + 1} to #{to + 1}"
    else
      puts "You cannot place a larger piece on a smaller one!"
    end
  end

  # 3. Check for valid user inputs
  def input
    valid = false

    # Loop until a valid input is entered
    until valid
      # Prompt for input
      print "Enter your move > "
      
      # Accept input from user
      user_input = gets.strip.to_s

      #Check to see if user quit... if so return
      if user_input == "q"
        @game_state = -1
        break;
      end

      #Otherwise split
      input_array = user_input.split(",")

      input_array.each_index { |i| input_array[i] = input_array[i].strip.to_i }

      # Check input to make sure it is valid
      if input_array.class == Array and input_array.size == 2 and input_array.all?{ |element| element.class == Fixnum }
        valid = true
        return input_array
      end
    end
    return nil
  end

	# 2. Create a game loop that finishes when the user either quits (for instance, by entering quit on the input line) or wins.
  #Each loop, display current board (render function), possible locations, and a prompt to enter the move
  # Game Loop
  def game_loop
    # Ask for the size of the tower from the player
    tower_size = ask_tower_size
    
    # Array of arrays to hold the columns from the game
    # Each piece represented by a number size 1 2 3 4 5... etc
    # The tens are placeholders and cannot be moved
    game_board = [[10],[10],[10]]

    starting_post = 0
    goal_post_1 = 1
    goal_post_2 = 2

    # Populate game board
    1.upto(tower_size) do |i|
      game_board[starting_post].push(1 + tower_size - i)
    end

    #Loop until a game over state is reached
    loop do
      # Render game state
      render(game_board, tower_size)
      
      # Prompt for new input 
      # If input is valid, change game state accordingly
      new_input = input
      if new_input != nil
        move(game_board, new_input)
      end

      # Check for victory
      if game_board[starting_post].size < 2 and (game_board[goal_post_1].size > tower_size or game_board[goal_post_2].size > tower_size)
        @game_state = 1
      end

      #break when user quits or wins
      if @game_state == -1
        puts "Bye, thanks for playing!"
        break
      elsif @game_state == 1
        render(game_board,tower_size)
        puts "You won! Congratulations!"
        break
      end
    end
  end

  def play
    welcome
    game_loop
	end
end

toh = ToH_Game.new

toh.play