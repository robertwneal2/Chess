module Slidable

  def possible_moves(board, exclude_castle_moves = false)
    moves = []
    self.class::MOVE_DIRECTIONS.each do |move_direction|
      new_pos = [@pos[0] + move_direction[0], @pos[1] + move_direction[1]]
      next if off_of_board?(new_pos)
      new_move_piece = board[new_pos]
      direction_blocked = false
      until direction_blocked
        if off_of_board?(new_pos) || new_move_piece.color == @color # Hit same color or edge of board
          direction_blocked = true 
        elsif new_move_piece.color != :null # Hit opponent piece
          moves << new_pos
          direction_blocked = true
        else # Empty space, update new_piece and new_pos
          moves << new_pos
          new_pos = [
            new_pos[0] + move_direction[0], 
            new_pos[1] + move_direction[1]
          ]
          if off_of_board?(new_pos)
            direction_blocked = true
            next
          end
          new_move_piece = board[new_pos]
        end
      end
    end
    moves
  end

end