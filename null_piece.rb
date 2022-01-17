require_relative 'piece'

class NullPiece < Piece

    def initialize(color, board, pos)
        super(color, board, pos)
    end

end