require_relative "../lib/chessGame"



=begin
  TODOS
  - each piece-Class: write #get_field_positions_on_way 
    - king
    - queen
    - bishop
    - knight -> give back empty array
  - chessBoard: 
    - for get_field_position check for nil -> return false then so player makes move again
    - write TDD for methods
    - finish #move_piece
  - chessGame:
    - write TDD for methods

=end

def print_explanations
  puts "WELCOME! You're about to play chess.\n"
  puts "You're always able to stop and save a started game at any point by typing "
  puts "    'save'"
  puts "You can also stop the game without saving it by typing "
  puts "    'exit'"
  puts
  puts "To declare your move type for example: "
  puts "    'a2a3'  "
  puts "to move a pawn from field a1 to field a2."
  puts 
  puts "Enough of this. Let's start!\n"
  #How to
  # - save game
  # - exit game
  # - start new game
  # - resume old game
end

def start_resume_game
  game_mode = get_game_mode()
  if game_mode == "start"
    start_new_game()
  elsif game_mode == "resume"
    resume_old_game()
  elsif game_mode == "exit"
    end_game()
  end
end

def get_game_mode
  print "Do you want to start a new game ('start') or resume a previous started one ('resume')?: " 
  input = gets.chomp.downcase
  until ["start", "resume", "exit"].include?(input)
    print "\nPlease type 'start' or 'resume': "
    input = gets.chomp.downcase
  end
  input
end

def start_new_game
  game = ChessGame.new
  game.start
end

def resume_old_game
  old_game_file = File.read('old_game.txt')
  old_game_obj = Marshal.load(old_game_file)
end

def end_game
  exit
end



print_explanations()
start_resume_game()






def save_game(obj)
  File.open('old_game.txt', 'w') do |file|
    file.puts obj
  end
end

#seredObj = Marshal.dump(game)
#save_game(seredObj)
