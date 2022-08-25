module Stepable

  def possible_moves
    moves = []
    self.class::MOVE_CHANGES.each do |move_change|
      new_pos = [@pos[0] + move_change[0], @pos[1] + move_change[1]]
      unless off_of_board?(new_pos) || @board[new_pos].color == @color
        moves << new_pos
      end
    end
    moves
  end

end