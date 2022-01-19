require_relative "piece"
require "byebug"

class Pawn < Piece

    def symbol 
        "♟"
    end

    def moves
        # debugger
        cur_row, cur_col = pos
        moves = []
        (1..forward_steps).each do |step|
            new_pos = [cur_row + (forward_dir*step), cur_col]
            new_row, new_col = new_pos
            prev_pos = [cur_row + forward_dir, new_col]
            if step == 2 && board[prev_pos].color == :none && board[new_pos].color == :none && new_row >= 0 && new_row <= 7
                moves << new_pos
            elsif step == 1 && board[new_pos].color == :none && new_row >= 0 && new_row <= 7
                moves << new_pos
            end
        end
        side_attacks.each do |attack_pos|
            # debugger
            attack_row, attack_col = attack_pos
            if attack_row >= 0 && attack_row <= 7 && attack_col >= 0 && attack_col <= 7 && board[attack_pos].color != :none && board[attack_pos].color != color
                moves << attack_pos
            end
        end
        moves
    end

    private

    def at_start_row?
        row, col = pos
        if color == :white && row == 1
            return true
        elsif color == :black && row == 7
            return true
        end
        false
    end

    def forward_dir
        if color == :white
            1
        else
            -1
        end
    end

    def forward_steps
        if at_start_row? == true
            2
        else
            1
        end
    end

    def side_attacks
        cur_row, cur_col = pos
        [[cur_row + forward_dir, cur_col +1], [cur_row + forward_dir, cur_col -1]]
    end

end