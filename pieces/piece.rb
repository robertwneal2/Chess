class Piece
    
    attr_writer :pos

    def initialize(color, board, pos)
        @color = color
        @board = board
        @pos = pos
    end

    def inspect
        [@color, @pos]
    end

end