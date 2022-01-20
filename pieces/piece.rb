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
        possible_moves = moves
        valid_moves = []
        possible_moves.each do |move|
            temp_board = @board.dup
            temp_board.move_piece!(pos, move)
            if temp_board.in_check?(color) == false
                valid_moves << move
            end
        end
        valid_moves
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