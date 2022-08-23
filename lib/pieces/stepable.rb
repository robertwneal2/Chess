module Stepable

  def possible_moves
    moves = []
    self.class::MOVE_CHANGES.each do |move_change|
      new_pos = [@pos[0] + move_change[0], @pos[1] + move_change[1]]
      new_move_piece = @board[new_pos]
      unless new_move_piece.color == @color || out_of_board?(new_pos)
        moves << new_pos
      end
    end
    moves
  end
  
  private
  
  def out_of_board?(pos)
    return true if pos[0] < 0 || pos[0] > 7 || pos[1] < 0 || pos[1] > 7
    false
  end

end