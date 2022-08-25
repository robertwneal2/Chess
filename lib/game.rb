require_relative 'board'
require_relative 'player'
require_relative 'computer'
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
      piece, new_pos = get_move
      set_last_move(piece, new_pos)
      @board.make_move(piece, new_pos)
      switch_turn
    end
    display_result
  end

  private

  def set_last_move(piece, new_pos)
    first_letter = LETTERS.key(piece.pos[1])
    first_num = NUMBERS.key(piece.pos[0])
    second_letter = LETTERS.key(new_pos[1])
    second_num = NUMBERS.key(new_pos[0])
    @last_move = first_letter + first_num + second_letter + second_num
  end

  def get_move
    system('clear')
    @board.display
    unless @last_move == nil
      puts "Last move: #{@last_move[0..1]} => #{@last_move[2..3]}"
    end
    piece = select_piece
    new_pos = select_pos
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
    puts "#{@current_turn.name} (#{@current_turn.color.to_s}) enter piece position:"
    piece_pos = gets.chomp
    until piece_pos.length == 2 && LETTERS.include?(piece_pos[0].upcase) && NUMBERS.include?(piece_pos[1])
      puts "Invalid piece selection, try again!"
      piece_pos = gets.chomp
    end
    piece_pos = [NUMBERS[piece_pos[1]], LETTERS[piece_pos[0].upcase]]
    @board[piece_pos]
  end

  def select_pos
    puts "Enter new position:"
    new_pos = gets.chomp
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

g = Game.new("Bert", "Rob")
g.play