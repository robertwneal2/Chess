require_relative 'piece'

class Pawn < Piece

  def initialize(color, pos = nil)
    super
    @start_row = pos[0]
    @start_row == 1 ? @dir = 1 : @dir = -1
  end

  def possible_moves(board, exclude_castle = false)
    moves = []
    straight_pos = [pos[0] + @dir, pos[1]]
    unless off_of_board?(straight_pos)
      straight_piece = board[straight_pos]

      if straight_piece.color == :null
        moves << straight_pos

        if @pos[0] == @start_row
          straight2_pos = [pos[0] + 2*@dir, pos[1]]
          straight2_piece = board[straight2_pos]
          moves << straight2_pos if straight2_piece.color == :null
        end
      end
    end

    [1, -1].each do |diag_dir|
      diag_pos = [pos[0] + @dir, pos[1] + diag_dir]
      unless off_of_board?(diag_pos)
        diag_piece = board[diag_pos]
        if diag_piece.color != :null && diag_piece.color != @color
          moves << diag_pos
        end
      end
    end

    moves
  end

end