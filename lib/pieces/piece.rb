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

  def inspect
    {color: @color, class: self.class, pos: @pos}
  end

  private
  
  def off_of_board?(pos)
    return true if pos[0] < 0 || pos[0] > 7 || pos[1] < 0 || pos[1] > 7
    false
  end

end