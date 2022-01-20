require 'byebug'
require_relative 'pieces'

class Board

    attr_accessor :rows

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
                raise StandardError.new("Positions must be 0 - 7")
            end
        end

        if self[start_pos] == @null_piece
            raise StandardError.new("No piece chosen!")
        end

        if self[start_pos].color != color
            raise StandardError.new("Can't move a piece that's not yours!")
        end

        if !self[start_pos].moves.include?(end_pos)
            raise StandardError.new("This piece can't move like that!")
        end

        if !self[start_pos].valid_moves.include?(end_pos)
            raise StandardError.new("Can't put self into check!")
        end

        piece = self[start_pos]
        piece.pos = end_pos
        self[end_pos] = piece
        self[start_pos] = @null_piece

    end

    def move_piece!(start_pos, end_pos)
        piece = self[start_pos]
        piece.pos = end_pos
        self[end_pos] = piece
        self[start_pos] = @null_piece
    end

    def valid_pos?(pos)
        pos.all? { |coord| coord.between?(0, 7) }
    end

    def in_check?(color)
        king_pos = find_king(color)
        @rows.each do |row|
            row.each_with_index do |piece, col|
                if piece.color != color
                    piece_moves = piece.moves
                    piece_moves.each do |end_pos|
                        return true if end_pos == king_pos
                    end
                end
            end
        end
        false
    end

    def checkmate?(color)
        if in_check?(color)
            @rows.each do |row|
                row.each do |piece|
                    if piece.color == color
                        piece_valid_moves = piece.valid_moves
                        return false if !piece_valid_moves.empty?
                    end
                end
            end
            true
        else
            false
        end
    end

    def find_king(color)
        @rows.each do |row|
            row.each do |piece|
                if piece.symbol == "♚" && color == piece.color
                    return piece.pos
                end
            end
        end
    end

    def dup
        # debugger
        board_dup = Board.new
        @rows.each_with_index do |entire_row, row|
            entire_row.each_with_index do |piece, col|
                piece_class = piece.class
                piece_color = piece.color
                piece_pos = [row,col]
                if piece_color == :none
                    piece_dup = @null_piece
                else
                    piece_dup = piece_class.new(piece_color, board_dup, piece_pos)
                end
                board_dup[[row, col]] = piece_dup
            end
        end
        board_dup
    end

end

if __FILE__ == $0
    board1 = Board.new
    f2 = [6,5]
    f3 = [5,5]
    e7 = [1,4]
    e5 = [3,4]
    g2 = [6,6]
    g4 = [4,6]
    d8 = [0,3]
    h4 = [4,7]
    a2 = [6,0]
    a3 = [5,0]
    
    board1.move_piece(a2,a3,:white)
    board1.move_piece(e7,e5,:black)
    board1.move_piece(g2,g4,:white)
    board1.move_piece(d8,h4,:black)
    board1.move_piece(f2,f3,:white)
    p board1.checkmate?(:white)
    p board1.checkmate?(:black)
end