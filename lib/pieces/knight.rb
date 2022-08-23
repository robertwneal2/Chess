require_relative 'piece'
require_relative 'stepable'

class Knight < Piece

  include Stepable

  MOVE_CHANGES = [
    [1, 2],
    [2, 1],
    [2, -1],
    [1, -2],
    [-1, 2],
    [-2, 1],
    [-2, -1],
    [-1, -2]
  ]

end