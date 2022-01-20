class Player 

    attr_reader :color, :name

    def initialize(color, display)
        @color = color
        @display = display
        if color == :white
            @name = "White"
        else
            @name = "Black"
        end
    end

end