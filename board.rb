require 'byebug'
require_relative 'null_piece'

class Board

    # attr_reader :rows

    def initialize
        @rows = Array.new(8) { Array.new }
        @null_piece = NullPiece
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
                    # color = :n
                    # pos = [row, col]
                    # row << Piece.new(color, self, pos)
                    entire_row << nil
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

        if self[start_pos] == nil
            raise "No piece at start pos" 
        end

        # if self[end_pos] != nil
        #     raise "Cannot move to end pos"
        # end

        piece = self[start_pos]
        self[end_pos] = piece
        self[start_pos] = nil
        piece.pos = end_pos

    end

end

if __FILE__ == $0
    board1 = Board.new
    # p board1.inspect
    pos1 = [0,0]
    pos2 = [2,0]
    p board1[pos1]
    p board1[pos2]
    board1.move_piece(pos1, pos2)
    # p board1.inspect
    p board1[pos1]
    p board1[pos2]
end