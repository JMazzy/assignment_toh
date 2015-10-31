#!/usr/bin/env ruby

# Procedural Tower of Hanoi Assignment

# Tower of Hanoi Game Class
class ToH_Game
  # Game state (playing=0 win=1 quit=-1)
  @game_state = 0

  # Set up
  # Display welcome message and instructions.
  def welcome
    puts "\n"
    puts "Welcome to Tower of Hanoi!"
    puts "\n"
    puts "Goal: Move the entire stack of disks from the starting post to one of the other posts."
    puts "\n"
    puts "Rules:"
    puts "1. Each move consists of moving the top disk in one stack to another stack."
    puts "2. No disk may be placed on top of a smaller disk."
    puts "\n"
    puts "Instructions:"
    puts "The stacks are labeled with numbers 1-3."
    puts "Enter where you'd like to move from and to in the format \"1,3\"."
    puts "Enter q to quit."
    puts "\n"
  end

  # Ask how big the player wants the tower to be
  def ask_tower_size
    # Max tower size
    min_tower_size = 3
    max_tower_size = 9

    puts "Enter the number of disks to use (must be between #{min_tower_size} and #{max_tower_size}) > "
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
    # Tower pieces to show relative size
    # Fill in empty space with spaces so pieces line up
    # Display a "base" under the tower
    # Display a "stick" when no piece is present
    pieces = [
      "        |        ", # the "stick", or piece size 0, used for nil rows
      "        O        ", # piece size 1 (and so on below... piece sizes correspond to array indices)
      "       (O)       ", 
      "      (OOO)      ", 
      "     (OOOOO)     ", 
      "    (OOOOOOO)    ", 
      "   (OOOOOOOOO)   ", 
      "  (OOOOOOOOOOO)  ", 
      " (OOOOOOOOOOOOO) ", 
      "(OOOOOOOOOOOOOOO)", 
      "TTTTTTTTTTTTTTTTT" # the "base", or piece size 10, always used under other pieces
    ]
    return pieces[piece_size]
  end

  # Method which prints out the current state of the game board in between turns
  def render(current_game_board, tower_size)
    # Display text 
    puts "Current Board: "

    # array of blank strings, initialized before adding content
    render_rows = ["","","","","","","","","","","",""]

    # Loop through to build the rows to render
    # Display number of rows corresponding to tower height
    # Display a column for each tower (split into rows for rendering)
    0.upto(tower_size) do |row|
      0.upto(2) do |column|
        # Display a blank area for "nil" "tower spots"
        if current_game_board[column] == nil or current_game_board[column][row] == nil
          # Shovel a blank piece into the render row
          render_rows[row] << tower_piece(0,tower_size)
        else
          # Set piece size to the corresponding board value
          piece_size = current_game_board[column][row]
          # Shovel the corresponding piece into the render row
          render_rows[row] << tower_piece(piece_size,tower_size)
        end
      end
    end

    #Render in reverse order (top to bottom) so it appears correctly
    render_rows.reverse_each do |row|
      puts row
    end

    #Label line - Display a row with column labels on it under the towers
    puts "[[[[[[[ 1 ]]]]]]][[[[[[[ 2 ]]]]]]][[[[[[[ 3 ]]]]]]]"
  end

  # Method to check for valid user inputs
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

      #Otherwise split input string into an array
      input_array = user_input.split(",")

      # Strip any spaces or newlines from each piece
      input_array.each_index { |i| input_array[i] = input_array[i].strip.to_i }

      # Check input to make sure it is valid
      if input_array.size == 2 and input_array.all?{ |element| element.class == Fixnum }
        if input_array.all?{ |num| num > 0 and num < 4 }
          valid = true
          return input_array
        else
          # message if player enters an invalid stack number
          puts "Please enter only valid stack numbers (1, 2, or 3)."
        end
      else
        # message if player enters in an incorrect format (resulting in the wrong number or type of arguments)
        puts "Please enter your move in the format \"1,3\"."
      end
    end
    #If loop reaches the end without returning, return nil (results in trying over from the beginning of the turn)
    return nil 
  end

  # Method to handle moves
  def move(current_game_board, from_to)
    # Separate from and to and convert from 1-indexed to 0-indexed
    from = from_to[0] - 1
    to = from_to[1] - 1

    # Check if the move is valid, if not do nothing but display a message
    if current_game_board[from].last < current_game_board[to].last
      # If valid, remove last item in the "from" column
      # place it in the "to" column (at the end) (array pop and push ?)
      current_game_board[to].push(current_game_board[from].pop)

      # Confirm the move with a message (converted back to 1-indexed column numbers)
      puts "Moved a piece from #{from + 1} to #{to + 1}"
    else
      # Message if player tries to place a larger piece on a smaller piece (against the game rules)
      puts "You cannot place a larger piece on a smaller one!"
    end
  end

  def check_win (game_board,tower_size)
    # Check for victory - player wins if entire tower is on a peg other than peg 0 (column 1)
    if game_board[1].size > tower_size or game_board[2].size > tower_size
      @game_state = 1
    end
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

    # Populate game board so all pieces are in the first tower
    1.upto(tower_size) do |i|
      game_board[starting_post].push(1 + tower_size - i)
    end

    #Loop until the player wins or quits
    loop do
      # Render game state
      render(game_board, tower_size)
      
      # Prompt for new input 
      # If input is valid, change game state accordingly
      new_input = input
      if new_input != nil
        move(game_board, new_input)
      end

      # Check to see if the player has won
      check_win(game_board,tower_size)

      #break when user quits or wins
      if @game_state == -1 # if user has quit
        #quit message
        puts "Bye, thanks for playing!"
        break
      elsif @game_state == 1 # if user has won
        # render the board one last time
        render(game_board,tower_size)
        # win message
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