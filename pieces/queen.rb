require_relative "piece"
require_relative 'slideable'

class Queen < Piece

    include Slideable

    def symbol
        "Q"
    end

    private
    def move_dirs
        horz_and_vert_dirs + diagonal_dirs
    end

end