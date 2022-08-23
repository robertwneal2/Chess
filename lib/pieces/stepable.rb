module Stepable

  def possible_moves
    moves = []
    self.class::MOVE_CHANGES.each do |move_change|
      new_pos = [@pos[0] + move_change[0], @pos[1] + move_change[1]]
      new_move_piece = @board[new_pos]
      unless new_move_piece.color == @color || off_of_board?(new_pos)
        moves << new_pos
      end
    end
    moves
  end

end