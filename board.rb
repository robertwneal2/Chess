require 'byebug'
require_relative 'pieces'

class Board

    attr_reader :rows

    def initialize
        @rows = Array.new(8) { Array.new }
        @null_piece = NullPiece.instance
        initialize_board
    end

    def initialize_board
        piece_row = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
        @rows.each_with_index do |entire_row, row|
            col = 0
            if row == 0
                piece_row.each do |piece|
                    color = :black
                    pos = [row, col]
                    entire_row << piece.new(color, self, pos)
                    col += 1
                end
            elsif row == 1
                8.times do 
                    color = :black
                    pos = [row, col]
                    entire_row << Pawn.new(color, self, pos)
                    col += 1
                end
            elsif row == 7
                piece_row.each do |piece|
                    color = :white
                    pos = [row, col]
                    entire_row << piece.new(color, self, pos)
                    col += 1
                end
            elsif row == 6
                8.times do 
                    color = :white
                    pos = [row, col]
                    entire_row << Pawn.new(color, self, pos)
                    col += 1
                end
            else
                8.times do 
                    entire_row << @null_piece
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

    def move_piece(start_pos, end_pos, color)
        # debugger
        start_row, start_col = start_pos
        end_row, end_col = end_pos
        inputs = [start_row, start_col, end_row, end_col]

        inputs.each do |input|
            if input < 0 || input > 7
                raise "Positions must be 0 - 7" 
            end
        end

        if self[start_pos] == @null_piece
            raise "No piece at start pos" 
        end

        if self[start_pos].color != color
            raise "Can't move a piece that's not yours!"
        end

        if !self[start_pos].moves.include?(end_pos)
            raise "Invalid move!"
        end

        piece = self[start_pos]
        piece.pos = end_pos
        self[end_pos] = piece
        self[start_pos] = @null_piece

    end

end

if __FILE__ == $0
    board1 = Board.new
    pos1 = [1,0]
    pos2 = [3,0]
    p board1[pos1]
    p board1[pos1].moves
    p board1[pos2]
    board1.move_piece(pos1, pos2, :w)
    p board1[pos1]
    p board1[pos2]
end