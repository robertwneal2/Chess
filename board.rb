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

    def valid_pos?(pos)
        pos.all? { |coord| coord.between?(0, 7) }
    end

    def in_check?(color)
        king_pos = find_king(color)
        @rows.each do |row|
            row.each_with_index do |piece, col|
                if piece.color != color
                    # piece_valid_moves = valid_moves(piece)
                    # piece_valid_moves.each do |end_pos|
                        # return true if end_pos = king_pos
                    # end
                end
            end
        end
        false
    end

    def checkmate?(color)
        if in_check?(color)
            @rows.each do |row|
                row.each_with_index do |piece, col|
                    if piece.color == color
                        # piece_valid_moves = valid_moves(piece)
                        # return true if piece_valid_moves.empty?
                    end
                end
            end
        end
        false
    end

    def find_king(color)
        @rows.each do |row|
            row.each_with_index do |piece, col|
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
    pos = [1,0]
    pos2 = [2,0]
    board2 = board1.dup
    board1.move_piece(pos, pos2, :black)
    p board1[pos]
    p board2[pos]
    p board1[pos2].board
    puts
    p board2[pos].board
    # p board1.in_check?(:white)
    # p board1.checkmate?(:white)
end