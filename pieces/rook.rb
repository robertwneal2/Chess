require_relative "piece"
require_relative 'slideable'

class Rook < Piece

    include Slideable

    def symbol
        "♜"
    end

    protected
    def move_dirs
        horz_and_vert_dirs
    end

end