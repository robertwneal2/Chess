require_relative 'piece'
require_relative 'slidable'

class Bishop < Piece

  include Slidable

  MOVE_DIRECTIONS = [
    [1, 1],
    [1, -1],
    [-1, -1],
    [-1, 1]
  ]

end