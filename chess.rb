require_relative 'board'
require_relative 'display'
require_relative 'human_player'
require 'byebug'

class Chess

    def initialize
        @board = Board.new
        @display = Display.new(@board)
        @player1 = HumanPlayer.new(:white, @display)
        @player2 = HumanPlayer.new(:black, @display)
        @current_player = @player1
    end

    def play 
        game_over = false
        system("clear")
        puts "To play, use arrow keys to move and space/enter to select/move a piece. Ctrl C to stop playing. Press anything to play!"
        @display.render
        @display.cursor.read_char
        while game_over == false
            begin
                start_pos, end_pos = @current_player.make_move(@board)
                color = @current_player.color
                # debugger
                @board.move_piece(start_pos, end_pos, color)
            rescue => e
                puts "#{e.message}"
                sleep(2)
                retry
            end

            if @board.checkmate?(:white) == true || @board.checkmate?(:black) == true
                game_over = true
            else
                swap_turn!
            end
        end
        system("clear")
        puts "#{@current_player.name} wins!"
        @display.render
    end

    private 
    def notifiy_players

    end

    def swap_turn!
        if @current_player == @player1
            @current_player = @player2
        else
            @current_player = @player1
        end
    end
    
end

if __FILE__ == $0
    chess1 = Chess.new
    chess1.play
end