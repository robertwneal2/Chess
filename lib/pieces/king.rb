require_relative 'piece'
require_relative 'stepable'

class King < Piece

  include Stepable

  MOVE_CHANGES = [
    [0, 1],
    [1, 1],
    [1, 0],
    [1, -1],
    [0, -1],
    [-1, -1],
    [-1, 0],
    [-1, 1]
  ]

end