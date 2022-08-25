require_relative 'piece'
require_relative 'slidable'

class Rook < Piece

  include Slidable

  MOVE_DIRECTIONS = [
    [0, 1],
    [0, -1],
    [1, 0],
    [-1, 0]
  ]

end