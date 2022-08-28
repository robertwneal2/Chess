class Piece

  attr_accessor :pos
  attr_reader :color

  def initialize(color, pos = nil) # nil position is empty 'piece'
    @color = color #:null for empty 
    @pos = pos
  end

  def valid_move?(pos, board)
    return false if possible_moves(board) == []

    # Cannot move king into check
    return false if board.pos_under_attack?(pos, @color) && self.class == King
    
    # Cannot keep King in check
    temp_board = board.clone_board
    temp_board.make_move(self, pos)
    return false if temp_board.check?(@color) == true
    
    possible_moves(board).include?(pos) ? true : false
  end

  def inspect
    {color: @color, class: self.class, pos: @pos}
  end

  private
  
  def off_of_board?(pos)
    return true if pos[0] < 0 || pos[0] > 7 || pos[1] < 0 || pos[1] > 7
    false
  end

  def possible_moves(board)
    [] # Null piece has no possible moves
  end

end