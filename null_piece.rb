require_relative 'piece'
require 'singleton'

class NullPiece < Piece

    include Singleton

    attr_reader :symbol

    def initialize
        @color = :n 
    end

    def moves

    end

end

if __FILE__ == $0
    p NullPiece.object_id
end

