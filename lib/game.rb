require_relative 'board'
require_relative 'player'
require_relative 'computer'
require_relative 'display'
require 'yaml'
require 'pry-byebug'

class Game

  NUMBERS = {
    "1" => 0,
    "2" => 1, 
    "3" => 2, 
    "4" => 3, 
    "5" => 4, 
    "6" => 5, 
    "7" => 6, 
    "8" => 7 
  }

  LETTERS = {
    "A" => 0,
    "B" => 1, 
    "C" => 2, 
    "D" => 3, 
    "E" => 4, 
    "F" => 5, 
    "G" => 6, 
    "H" => 7
  }

  def initialize(name1 = 'White', name2 = 'Black')
    @player1 = create_player(name1, :white)
    @player2 = create_player(name2, :black)
    @current_turn = @player1
    @board = Board.new(@player1, @player2)
    @display = Display.new(@board)
  end

  def play
    until game_over?
      piece, new_pos = get_move
      break if game_saved?(piece)
      make_move(piece, new_pos)
      switch_turn
    end
    display_result unless piece == :save
  end

  private

  def create_player(name, color)
    if name.downcase == 'computer'
      Computer.new(color)
    else
      Player.new(name, color)
    end
  end

  def game_over?
    return true if checkmate?
    return true if draw?
    return true if stalemate?
    false
  end

  def checkmate?
    current_color = @current_turn.color
    king_pos = @board.find_king_pos(current_color)
    king = @board[king_pos]
    king_moves = king.possible_moves(@board)

    # King doesn't have to move
    return false unless @board.pos_under_attack?(king.pos, current_color) 

    # King move to safety
    king_moves.each do |move|
      # temp_board = @board.clone_board
      # temp_board.make_move(king, move)
      return false if king.valid_move?(move, @board)
    end

    # Other piece can save King
    return false if @board.save_move?(current_color)

    true
  end

  def check?
    puts 'Check!' if @board.check?(@current_turn.color)
  end

  def draw?
    piece_count = @board.board.flatten.count { |piece| piece.color != :null }
    return true if piece_count == 2
  end

  def stalemate?
    pieces = color = @current_turn.color
    pieces = @board.board.flatten.select { |piece| piece.color == color }
    valid_moves = []
    pieces.each do |piece|
      possible_moves = piece.possible_moves(@board)
      possible_moves.each do |move|
        valid_moves << move if piece.valid_move?(move, @board)
      end
    end
    return true if valid_moves == [] && !check?
    false
  end

  def get_move
    if @current_turn.class == Computer
      display_board
      moves = computer_move
      # Pause if tow computer players to see move
      if @player1.class == Computer && @player2.class == Computer
        # sleep(0.1)
      end
      return moves
    end
    moves = select_positions
    return moves if moves[0] == :save
    piece = @board[moves[0]]
    new_pos = moves[1]
    until piece.color == @current_turn.color && piece.valid_move?(new_pos, @board)
      moves = get_move
      piece = moves[0]
      new_pos = moves[1]
    end
    moves[0] = piece
    moves
  end

  def select_positions
    input_count = 0
    moves = []
    while input_count < 2
      display_board
      move = @display.cursor.get_input
      if move == :save
        return [:save]
      elsif move != nil && move == moves[0]
        input_count = 0
        moves = []
      elsif move != nil
        input_count += 1
        moves << move
      end
    end
    moves
  end

  def computer_move
    # binding.pry
    color = @current_turn.color
    pieces = @board.board.flatten.select { |piece| piece.color == color }
    piece = pieces.sample
    new_pos = piece.pos
    until piece.valid_move?(new_pos, @board)
      piece = pieces.sample
      possible_moves = piece.possible_moves(@board)
      new_pos = possible_moves.sample
    end
    [piece, new_pos]
  end

  def display_board
    system('clear')
    @display.render
    puts "#{@current_turn.name.capitalize}'s turn (#{@current_turn.color.to_s.capitalize})"
    check?
  end

  def make_move(piece, new_pos)
    @board.make_move(piece, new_pos)
    @board.pawn_promotion?(piece, new_pos)
    @board.update_piece
  end

  def switch_turn
    if @current_turn == @player1
      @current_turn = @player2
    else
      @current_turn = @player1
    end
  end

  def display_result
    system("clear")
    @display.render
    if checkmate?
      switch_turn
      puts "Checkmate! #{@current_turn.name} (#{@current_turn.color.to_s.capitalize}) wins!"
    else
      puts "Draw! (#{@current_turn.color.to_s.capitalize}'s turn)"
    end
  end

  def game_saved?(piece)
    if piece == :save
      save_game
      return true 
    end
    false
  end

  def save_game
    puts 'Enter save name:'
    save_name = gets.chomp
    while save_name == ''
      puts "Name cannot be empty, try again:"
      save_name = gets.chomp
    end
    game_yml = self.to_yaml
    current_dir =  File.dirname(__FILE__)
    File.write("#{current_dir}/saves/#{save_name}.yml", game_yml)
    puts "Game saved to: #{current_dir}/saves/#{save_name}.yml"
  end

end

def new_game
  system('clear')
  puts 'New game!'

  puts "Enter Player 1 name ('computer' for computer player):"
  player1_name = gets.chomp
  while player1_name == ''
    puts "Name cannot be empty, try again:"
  end

  puts "Enter Player 2 name:('computer' for computer player)"
  player2_name = gets.chomp
  while player2_name == ''
    puts "Name cannot be empty, try again:"
  end

  game = Game.new(player1_name, player2_name)
end

permitted_classes = [
  Game, 
  Board, 
  Player,
  Piece,
  King,
  Queen,
  Rook,
  Bishop,
  Pawn,
  Knight,
  Symbol,
  Display,
  Cursor
]

system("clear")
puts "Load game? Enter Y/N"
load_input = gets.chomp.upcase
if load_input == 'Y'
  loop_done = false
  puts 'Enter file name or \'new\' to start a new game:'
  while loop_done == false do
    current_dir =  File.dirname(__FILE__)
    file_name = gets.chomp
    file_path = "#{current_dir}/saves/#{file_name}.yml"
    if file_name.upcase == 'NEW'
      game = new_game
      loop_done = true
    elsif File.exist?(file_path)
      game = YAML.load(File.read(file_path), aliases: true, permitted_classes: permitted_classes)
      loop_done = true
    else
      puts 'File name does not exist, try again:'
    end
  end
else
  game = new_game
end

game.play