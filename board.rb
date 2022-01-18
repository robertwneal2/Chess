require 'byebug'
require_relative 'pieces'

class Board

    # attr_reader :rows

    def initialize
        @rows = Array.new(8) { Array.new }
        @null_piece = NullPiece.instance
        initialize_board
    end

    def initialize_board
        @rows.each_with_index do |entire_row, row|
            col = 0
            if row == 0 || row == 1
                8.times do 
                    color = :w
                    pos = [row, col]
                    entire_row << Piece.new(color, self, pos)
                    col += 1
                end
            elsif row == 6 || row == 7
                8.times do 
                    color = :b
                    pos = [row, col]
                    entire_row << Piece.new(color, self, pos)
                    col += 1
                end
            else
                8.times do 
                    entire_row << @null_piece
                    col += 1
                end
            end
        end

    end

    def inspect
        @rows
    end

    def [](pos)
        row, col = pos
        @rows[row][col]
    end

    def []=(pos,val)
        row, col = pos
        @rows[row][col] = val
    end

    def move_piece(start_pos, end_pos)
        # debugger
        start_row, start_col = start_pos
        end_row, end_col = end_pos
        inputs = [start_row, start_col, end_row, end_col]

        inputs.each do |input|
            if input < 0 || input > 7
                raise "positions must be 0 - 7" 
            end
        end

        if self[start_pos] == @null_piece
            raise "No piece at start pos" 
        end

        # if self[end_pos] != nil
        #     raise "Cannot move to end pos"
        # end

        # debugger
        piece = self[start_pos]
        piece.pos = end_pos
        self[end_pos] = piece
        self[start_pos] = @null_piece

    end

end

if __FILE__ == $0
    board1 = Board.new
    # p board1.inspect
    pos = [3,1]
    pos2 = [4,0]
    board1[pos] = Queen.new(:w, board1, pos)
    p board1[pos].moves
end