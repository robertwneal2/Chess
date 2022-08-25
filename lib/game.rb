require_relative 'board'
require_relative 'player'
require_relative 'computer'
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
    @board = Board.new
    @player1 = create_player(name1, :white)
    @player2 = create_player(name2, :black)
    @current_turn = @player1
    @last_move = nil
  end

  def play
    until game_over?
      system('clear')
      @board.display
      piece, new_pos = get_move
      break if game_saved?(piece)
      set_last_move(piece, new_pos)
      @board.make_move(piece, new_pos)
      switch_turn
    end
    display_result unless piece == :save
  end

  private

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

  def set_last_move(piece, new_pos)
    first_letter = LETTERS.key(piece.pos[1])
    first_num = NUMBERS.key(piece.pos[0])
    second_letter = LETTERS.key(new_pos[1])
    second_num = NUMBERS.key(new_pos[0])
    @last_move = first_letter + first_num + second_letter + second_num
  end

  def get_move
    unless @last_move == nil
      puts "Last move: #{@last_move[0..1]} => #{@last_move[2..3]}"
    end
    piece = select_piece
    return :save if piece == :save
    new_pos = select_pos
    return :save if new_pos == :save
    until piece.valid_move?(new_pos) && piece.color == @current_turn.color
      system('clear')
      @board.display
      puts 'Invalid move, try again!'
      piece = select_piece
      new_pos = select_pos
    end 
    [piece, new_pos]
  end

  def switch_turn
    if @current_turn == @player1
      @current_turn = @player2
    else
      @current_turn = @player1
    end
  end

  def create_player(name, color)
    if name.downcase == 'computer'
      Computer.new(color)
    else
      Player.new(name, color)
    end
  end

  def select_piece
    puts "#{@current_turn.name} (#{@current_turn.color.to_s}) enter piece position ('s' to save):"
    piece_pos = gets.chomp
    return :save if piece_pos.downcase == 's'
    until piece_pos.length == 2 && LETTERS.include?(piece_pos[0].upcase) && NUMBERS.include?(piece_pos[1])
      puts "Invalid piece selection, try again!"
      piece_pos = gets.chomp
    end
    piece_pos = [NUMBERS[piece_pos[1]], LETTERS[piece_pos[0].upcase]]
    @board[piece_pos]
  end

  def select_pos
    puts "Enter new position ('s' to save):"
    new_pos = gets.chomp
    return :save if new_pos.downcase == 's'
    until new_pos.length == 2 && LETTERS.include?(new_pos[0].upcase) && NUMBERS.include?(new_pos[1])
      puts "Invalid new position, try again!"
      new_pos = gets.chomp
    end
    new_pos = [NUMBERS[new_pos[1]] ,LETTERS[new_pos[0].upcase]]
  end

  def game_over?
    king_count = @board.board.flatten.count { |piece| piece.class == King }
    return false if king_count == 2
    true
  end

  def display_result
    switch_turn
    system('clear')
    @board.display
    puts "Last move: #{@last_move[0..1]} => #{@last_move[2..3]}"
    puts "#{@current_turn.name} wins!"
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
  Symbol
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