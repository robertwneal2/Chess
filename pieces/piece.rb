class Piece
    
    attr_reader :color, :board
    attr_accessor :pos

    def initialize(color, board, pos)
        @color = color
        @board = board
        @pos = pos
    end

    def inspect
        [color, symbol, pos]
    end

    def to_s

    end

    def empty?

    end

    def valid_moves

    end

    # def pos=(val)
        
    # end

    def symbol
        # subclass implements this with unicode chess char
        raise NotImplementedError
    end

    private
    def move_into_check(end_pos)

    end

end