class Piece

  attr_accessor :pos
  attr_reader :color, :board

  def initialize(color, board, pos = nil) # nil position is empty 'piece'
    @color = color #:null for empty 
    @pos = pos
    @board = board
  end

  def valid_move?(new_pos)
    possible_moves.include?(new_pos) ? true : false
  end

end