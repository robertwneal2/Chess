require_relative '../lib/pieces/knight'

describe Knight do

  describe '#possible_moves' do

    context 'when in middle of board surround by empty spaces' do
      subject(:knight_empty) { described_class.new(:white, [4, 4]) }
      let(:board) { double('board') }
      let(:piece) { double('piece', color: :null) }

      it 'returns correct 8 moves' do
        allow(board).to receive(:[]).and_return(piece)
        expected_result = [
          [5, 6],
          [6, 5],
          [6, 3],
          [5, 2],
          [3, 6],
          [2, 5],
          [2, 3],
          [3, 2]
        ]
        result = knight_empty.possible_moves(board)
        expect(result).to eq(expected_result)
      end
    end

    context 'when in corner surrounded by empty spaces' do
      subject(:knight_empty_corner) { described_class.new(:white, [0, 0]) }
      let(:board) { double('board') }
      let(:piece) { double('piece', color: :null) }

      it 'returns correct 3 moves' do
        allow(board).to receive(:[]).and_return(piece)
        expected_result = [
          [1, 2],
          [2, 1]
        ]
        result = knight_empty_corner.possible_moves(board)
        expect(result).to eq(expected_result)
      end
    end

    context 'when in corner and blocked by white pieces' do
      subject(:knight_empty_corner_white) { described_class.new(:white, [0, 0]) }
      let(:board) { double('board') }
      let(:piece) { double('piece', color: :white) }
  
      it 'returns no moves' do
        allow(board).to receive(:[]).and_return(piece)
        expected_result = []
        result = knight_empty_corner_white.possible_moves(board)
        expect(result).to eq(expected_result)
      end
    end

    context 'when in corner and blocked by black pieces' do
      subject(:knight_empty_corner_black) { described_class.new(:white, [0, 0]) }
      let(:board) { double('board') }
      let(:piece) { double('piece', color: :black) }
    
      it 'returns correct 3 moves' do
        allow(board).to receive(:[]).and_return(piece)
        expected_result = [
          [1, 2],
          [2, 1]
        ]
        result = knight_empty_corner_black.possible_moves(board)
        expect(result).to eq(expected_result)
      end
    end

  end

end