require_relative 'board'
require_relative 'player'
require_relative 'computer'

class Game

  def initialize(name1 = 'White', name2 = 'Black')
    @board = Board.new
    @player1 = create_player(name1, :white)
    @player1 = create_player(name2, :black)
  end

  def play
    until game_over?
      puts "#{@current_turn.name}'s turn"
      piece = select_piece
      new_pos = select_pos
      until piece.valid_move?(new_pos)
        puts 'Invalid move, try again'
        piece = select_piece
        new_pos = select_pos
      end
      @board.make_move(piece, new_pos)
    end
  end

  private

  def switch_turn
    if @current_turn == @player1
      @current_turn = @player2
    else
      @current_turn = @player1
    end
  end

  def create_player(name, color)
    if name.downcase == 'computer'
      Computer.new(color)
    else
      Player.new(name, color)
    end
  end

  def select_piece

  end

  def select_pos

  end

end

system('clear')