require_relative 'piece'

class Pawn < Piece

  def initialize(color, board, pos = nil)
    super
    @start_row = pos[0]
    @start_row == 1 ? @dir = 1 : @dir = -1
  end

  def possible_moves
    moves = []
    straight_pos = [pos[0] + @dir, pos[1]]
    unless off_of_board?(straight_pos)
      straight_piece = @board[straight_pos]

      if straight_piece.color == :null
        moves << straight_pos

        if @pos[0] == @start_row
          straight2_pos = [pos[0] + 2*@dir, pos[1]]
          straight2_piece = @board[straight2_pos]
          moves << straight2_pos if straight2_piece.color == :null
        end
      end
    end

    diag1_pos = [pos[0] + @dir, pos[1] + 1]
    unless off_of_board?(diag1_pos)
      diag1_piece = @board[diag1_pos]

      if diag1_piece.color != :null && diag1_piece.color != @color
        moves << diag1_pos
      end
    end

    diag2_pos = [pos[0] + @dir, pos[1] - 1]
    unless off_of_board?(diag2_pos)
      diag2_piece = @board[diag2_pos]

      if diag2_piece.color != :null && diag2_piece.color != @color
        moves << diag2_pos
      end
    end

    moves
  end

end