require_relative 'piece'
require_relative 'stepable'

class King < Piece

  include Stepable

  attr_accessor :moved

  def initialize(color, pos = nil)
    super
    @moved = false
  end

  MOVE_CHANGES = [
    [0, 1],
    [1, 1],
    [1, 0],
    [1, -1],
    [0, -1],
    [-1, -1],
    [-1, 0],
    [-1, 1]
  ]

  private

  def castle_moves(board)
    return [] if @moved == true
    row = self.pos[0]
    king_col = self.pos[1]
    moves = []
    rooks  = []
    [0, 7].each do |col|
      pos = [row, col]
      piece = board[pos]
      if piece.class == Rook && piece.color == @color && piece.moved == false
        rooks << piece
      end
    end

    rooks.each do |rook|
      rook_col = rook.pos[1]
      if rook_col == 0 
        new_rook_col = 3
        new_king_col = 2
        empty_space_arr = [1, 2, 3]
        under_attack_arr = [2, 3, 4] 
      else 
        new_rook_col = 5
        new_king_col = 6
        empty_space_arr = [5, 6]
        under_attack_arr = [4, 5, 6]  
      end

      #check all spaces between King and Rook are empty 
      all_empty = true 
      empty_space_arr.each do |col|
        pos = [row, col]
        piece = board[pos]
        all_empty = false unless piece.color == :null
      end

      if all_empty == true
        move = [row, new_king_col]

        # Check if any spaces king is on or moves through/to is under attack
        under_attack = false
        under_attack_arr.each do |col|
          pos = [row, col]
          under_attack = true if board.pos_under_attack?(pos, @color)
        end

        if under_attack == false
          moves << move
        end
      end
    end
    moves
  end

end