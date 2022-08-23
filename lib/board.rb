class Board 

  def initialize
    @board = generate_board
  end

  def display

  end

  def make_move(piece, new_pos)
    @board[new_pos[0]][new_pos[1]] = piece
  end

  def [](pos)
    @board[pos[0], pos[1]]
  end

  private

  def generate_board

  end

end