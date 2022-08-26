require_relative 'pieces'
require 'colorize'

class Board 

  SYMBOLS = {
    "Bishop" => "\u265D",
    "Knight" => "\u265E",
    "Rook" => "\u265C",
    "Queen" => "\u265B",
    "King" => "\u265A",
    "Pawn" => "\u265F",
    "Piece" => " "
  }

  BACKGROUND_COLORS = [:light_red, :light_black]

  attr_reader :board

  def initialize
    @empty_space = Piece.new(:null, self)
    @board = generate_board
  end

  def display
    background_color = BACKGROUND_COLORS[0]
    row_i = 9
    @board.reverse_each do |row|
      row_i -= 1
      display_row = "#{row_i}"
      row.each_with_index do |piece, col|
        color = piece.color
        symbol = SYMBOLS[piece.class.to_s] + " "
        display_row += symbol.colorize(:color => color, :background => background_color)
        
        if col == 7
        elsif background_color == BACKGROUND_COLORS[0]
            background_color = BACKGROUND_COLORS[1]
        else
          background_color = BACKGROUND_COLORS[0]
        end
      end
      puts display_row
    end
    puts " A B C D E F G H"
  end

  def make_move(piece, new_pos)
    old_pos = piece.pos
    piece.pos = new_pos # Update new pos of piece
    self[old_pos] = @empty_space
    self[new_pos] = piece # Move piece on board
  end

  def [](pos)
    @board[pos[0]][pos[1]]
  end

  def find_king(current_color)
    all_squares = @board.flatten
    all_squares.each do |piece|
      if piece.color == current_color && piece.class == King
        return piece
      end
    end
  end

  def pos_under_attack?(pos, color)
    if color == :white 
      opposing_color = :black
    else
      opposing_color = :white
    end

    all_opposing_moves = []
    all_squares = @board.flatten
    all_squares.each do |piece|
      if piece.color == opposing_color
        all_opposing_moves += piece.possible_moves
      end
    end
    return true if all_opposing_moves.include?(pos)
    false
  end

  private

  def generate_board
    board_arr = Array.new(8) { Array.new(8, @empty_space) } # Start with all spaces as empty space
    board_arr[0][0] = Rook.new(:white, self, [0, 0]) # White non-pawn pieces
    board_arr[0][1] = Knight.new(:white, self, [0, 1])
    board_arr[0][2] = Bishop.new(:white, self, [0, 2])
    board_arr[0][3] = Queen.new(:white, self, [0, 3])
    board_arr[0][4] = King.new(:white, self, [0, 4])
    board_arr[0][5] = Bishop.new(:white, self, [0, 5])
    board_arr[0][6] = Knight.new(:white, self, [0, 6])
    board_arr[0][7] = Rook.new(:white, self, [0, 7])

    board_arr[7][0] = Rook.new(:black, self, [7, 0]) # Black non-pawn pieces
    board_arr[7][1] = Knight.new(:black, self, [7, 1])
    board_arr[7][2] = Bishop.new(:black, self, [7, 2])
    board_arr[7][3] = Queen.new(:black, self, [7, 3])
    board_arr[7][4] = King.new(:black, self, [7, 4])
    board_arr[7][5] = Bishop.new(:black, self, [7, 5])
    board_arr[7][6] = Knight.new(:black, self, [7, 6])
    board_arr[7][7] = Rook.new(:black, self, [7, 7])
    
    (0..7).each do |col|
      board_arr[6][col] = Pawn.new(:black, self, [6, col])
      board_arr[1][col] = Pawn.new(:white, self, [1, col])
    end

    board_arr
  end

  def []=(pos, piece)
    @board[pos[0]][pos[1]] = piece
  end

end

b = Board.new

