module Stepable

    def moves
        moves = []
        start_x, start_y = pos
        move_diffs.each do |move_diff|
            dx, dy = move_diff
            cur_x = start_x + dx
            cur_y = start_y + dy
            cur_pos = [cur_x, cur_y]
            if cur_x < 0 || cur_x > 7 || cur_y < 0 || cur_y > 7
                #off board, do nothing
            elsif board[cur_pos].color == color
                #same color, do nothing
            elsif board[cur_pos].color != :none && board[cur_pos].color != color
                #take out opponent piece
                moves << cur_pos
            else
                #move to empty pos
                moves << cur_pos
            end
        end
        moves
    end

    private
    
    def move_diffs
    # subclass implements this
    raise NotImplementedError
  end

end