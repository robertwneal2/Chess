require_relative 'player'

class HumanPlayer < Player

    def make_move(board)
    input_count = 0
    moves = []
        while input_count < 2
            system"clear"
            puts "#{name}'s turn"
            @display.render
            move = @display.cursor.get_input
            if move != nil && move == moves[0]
                input_count = 0
                moves = []
            elsif move != nil
                input_count += 1
                moves << move
            end
        end
        moves
    end

end