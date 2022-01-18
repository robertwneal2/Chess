module Slideable

    HORIZONTAL_AND_VERT_DIRS = [[-1, 0], [1, 0], [0, 1], [0,-1]]
    DIAGONAL_DIRS = [[-1, -1], [-1, 1], [1, -1], [1, 1]]

    def horz_and_vert_dirs
        HORIZONTAL_AND_VERT_DIRS
    end

    def diagonal_dirs
        DIAGONAL_DIRS
    end

    def moves
        # debugger
        moves = []
        move_dirs.each do |move_dir|
            dx = move_dir[0]
            dy = move_dir[1]
            moves += grow_unblocked_moves_in_dir(dx, dy)
        end
        moves
    end

    private

    def move_dirs
    # subclass implements this
    raise NotImplementedError
    end

    def grow_unblocked_moves_in_dir(dx, dy)
        cur_x, cur_y = pos
        blocked = false
        off_board = false
        moves = []
        while blocked == false && off_board == false
            cur_x += dx
            cur_y += dy
            cur_pos = [cur_x, cur_y]
            if cur_x < 0 || cur_x > 7 || cur_y < 0 || cur_y > 7
                off_board = true 
            elsif board[cur_pos].color == color
                blocked = true
            elsif board[cur_pos].color != :none && board[cur_pos].color != color
                moves << cur_pos
                blocked = true
            else
                moves << cur_pos
            end
        end
        moves
    end

end