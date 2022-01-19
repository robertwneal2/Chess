require_relative 'board'
require 'colorize'
require_relative 'cursor'

class Display

    def initialize(board)
        # @cursor = Cursor.new([0,0], board)
        @board = board
    end

    def render
        grid = @board.rows
        grid.each_with_index do |row, row_i|
            row_val = ""
            row.each_with_index do |square, col|
                piece = square.symbol
                piece_color = square.color
                if row_i % 2 == 0 && col % 2 == 0
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
    board1 = Board.new
    display1 = Display.new(board1)
    display1.render
end