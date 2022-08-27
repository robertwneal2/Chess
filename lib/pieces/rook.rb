require_relative 'piece'
require_relative 'slidable'

class Rook < Piece

  include Slidable

  attr_accessor :moved

  def initialize(color, pos = nil)
    super
    @moved = false
  end

  MOVE_DIRECTIONS = [
    [0, 1],
    [0, -1],
    [1, 0],
    [-1, 0]
  ]

end