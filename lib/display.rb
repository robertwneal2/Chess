require_relative 'board'
require 'colorize'
require_relative 'cursor'

class Display

  SYMBOLS = {
    "Bishop" => "\u265D",
    "Knight" => "\u265E",
    "Rook" => "\u265C",
    "Queen" => "\u265B",
    "King" => "\u265A",
    "Pawn" => "\u265F",
    "Piece" => " "
  }

  attr_reader :board, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([7,0], board)
  end

  def render
    grid = @board.board
    cursor_x, cursor_y = @cursor.cursor_pos
    cursor_color = :cyan
    selected_color = :green
    selected = @cursor.selected
    if selected
        selected_x, selected_y = @cursor.selected_pos
    end
    grid.each_with_index do |row, row_i|
      row_val = ""
      row.each_with_index do |square, col|
        piece = SYMBOLS[square.class.to_s]
        piece_color = square.color
        if row_i == selected_x && col == selected_y
          background_color = selected_color
        elsif row_i == cursor_x && col == cursor_y
          background_color = cursor_color
        elsif row_i % 2 == 0 && col % 2 == 0
          background_color = :light_black
        elsif row_i % 2 == 0 && col % 2 == 1
          background_color = :light_red
        elsif row_i % 2 == 1 && col % 2 == 0
          background_color = :light_red
        else
          background_color = :light_black
        end
        row_val += "#{piece} ".colorize(:color => piece_color, :background => background_color)
      end
      puts row_val
    end
  end
end

if __FILE__ == $0
  system("clear")
  board1 = Board.new
  display1 = Display.new(board1)
  while 1 == 1
    display1.render
    display1.cursor.get_input
    system("clear")
  end
end