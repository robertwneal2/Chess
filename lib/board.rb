require_relative 'pieces'
require 'colorize'
require 'pry-byebug'

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
    @empty_space = Piece.new(:null)
    @board = generate_board
    @en_passant_pos = nil
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
    # piece.pos = new_pos # Update new pos of piece
    self[old_pos] = @empty_space
    self[new_pos] = piece # Move piece on board

    # Castle 
    if piece.class == King && piece.moved == false
      pos_diff = (old_pos[1] - new_pos[1]).abs()
      castle(piece, new_pos) if pos_diff == 2
    end

    # Remove pawn if en passant space is landed on by pawn
    if new_pos == @en_passant_pos && piece.class == Pawn
      new_pos[0] == 2 ? dead_pawn_row = 3 : dead_pawn_row = 4
      dead_pawn_pos = [dead_pawn_row, new_pos[1]]
      self[dead_pawn_pos] = @empty_space
    end

    # Place en passant piece on jumped space
    if piece.class == Pawn && (old_pos[0] - new_pos[0]).abs() == 2
      old_pos[0] == 1 ? en_passant_row = 2 : en_passant_row = 5
      @en_passant_pos = [en_passant_row, old_pos[1]]
      en_passant_piece = Piece.new(@en_passant_pos, piece.color)
      self[@en_passant_pos] = en_passant_piece
    else
      @en_passant_pos = nil
    end
  end

  # Update piece instance variables after move is made. Do this to not change piece objects during Game#checkmate due to board cloning (not a deep clone)
  def update_piece 
    @board.each_with_index do |row, row_i|
      row.each_with_index do |piece, col_i|
        new_pos = [row_i, col_i]
        
        # Update King@moved or Rook@moved
        if (piece.class == King || piece.class == Rook) && piece.pos != new_pos && piece.moved == false
          piece.moved = true
        end

        # Remove en passant space
        if new_pos != @en_passant_pos &&  piece.class == Piece && piece.color != :null
          self[new_pos] = @empty_space
        end

        piece.pos = new_pos unless piece.color == :null
      end
    end

    #En passant update
    unless @en_passant_piece.nil?

    end
  end

  def castle(king, pos)
    row = pos[0]
    king_col = pos[1]
    if king_col > 4 
      rook_col = 7
      new_rook_col = 5
    else
      rook_col = 0
      new_rook_col = 3
    end
    rook = self[[row, rook_col]]
    new_rook_pos = [row, new_rook_col]
    make_move(rook, new_rook_pos)
  end

  def save_move?(color)
    # Grab all pieces of same color that are not kings
    @board.flatten.each do |piece|
      if piece.color == color && piece.class != King
        moves = piece.possible_moves(self)
        moves.each do |move|
          temp_board = clone_board
          temp_board.make_move(piece, move)
          return true unless temp_board.check?(color) #any moves that can save king?
        end
      end
    end

    false
  end

  def [](pos)
    @board[pos[0]][pos[1]]
  end

  def find_king_pos(color)
    @board.each_with_index do |row, row_i|
      row.each_with_index do |piece, col_i|
        return[row_i, col_i] if piece.class == King && piece.color == color
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
        all_opposing_moves += piece.possible_moves(self, true)
      end
    end
    all_opposing_moves
    return true if all_opposing_moves.include?(pos)
    false
  end

  def check?(color)
    king_pos = find_king_pos(color)
    return true if pos_under_attack?(king_pos, color)
    false
  end

  def pawn_promotion?(piece, pos)
    if piece.class == Pawn && (pos[0] == 7 || pos[0] == 0) # Pawn on final row?
      pieces = {
        "Q" => Queen,
        "K" => Knight,
        "R" => Rook,
        "B" => Bishop
      }
      piece_color = piece.color
      puts "Enter new piece to replace pawn with (Q, K, R, B)"
      piece_letter = gets.chomp
      until pieces.include?(piece_letter.upcase)
        puts "Try again!"
        piece_letter = gets.chomp
      end
      new_class = pieces[piece_letter.upcase]
      new_piece = new_class.new(piece_color, pos)
      self.make_move(new_piece, pos)
    end
  end

  def clone_board
    temp_board_class = self.clone
    temp_board_class.board = @board.clone.map(&:clone)
    temp_board_class
  end

  protected

  def board=(new_board)
    @board = new_board
  end

  private

  def generate_board
    board_arr = Array.new(8) { Array.new(8, @empty_space) } # Start with all spaces as empty space
    board_arr[0][0] = Rook.new(:white, [0, 0]) # White non-pawn pieces
    board_arr[0][1] = Knight.new(:white, [0, 1])
    board_arr[0][2] = Bishop.new(:white, [0, 2])
    board_arr[0][3] = Queen.new(:white, [0, 3])
    board_arr[0][4] = King.new(:white, [0, 4])
    board_arr[0][5] = Bishop.new(:white, [0, 5])
    board_arr[0][6] = Knight.new(:white, [0, 6])
    board_arr[0][7] = Rook.new(:white, [0, 7])

    board_arr[7][0] = Rook.new(:black, [7, 0]) # Black non-pawn pieces
    board_arr[7][1] = Knight.new(:black, [7, 1])
    board_arr[7][2] = Bishop.new(:black, [7, 2])
    board_arr[7][3] = Queen.new(:black, [7, 3])
    board_arr[7][4] = King.new(:black, [7, 4])
    board_arr[7][5] = Bishop.new(:black, [7, 5])
    board_arr[7][6] = Knight.new(:black, [7, 6])
    board_arr[7][7] = Rook.new(:black, [7, 7])
    
    (0..7).each do |col|
      board_arr[6][col] = Pawn.new(:black, [6, col])
      board_arr[1][col] = Pawn.new(:white, [1, col])
    end

    board_arr
  end

  def []=(pos, piece)
    @board[pos[0]][pos[1]] = piece
  end

end

b = Board.new

