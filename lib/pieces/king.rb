require_relative 'piece'

class King < Piece

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

  def possible_moves
    moves = []
    MOVE_CHANGES.each do |move_change|
      new_pos = [@pos[0] + move_change[0], @pos[1] + move_change[1]]
      new_move_piece = @board[new_pos]
      unless new_move_piece.color == @color || new_pos[0] < 0 || 
      new_pos[0] > 7 || new_pos[1] < 0 || new_pos[1] > 7
        moves << new_pos
      end
    end
    moves
  end

end