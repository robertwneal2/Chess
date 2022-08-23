require_relative '../lib/pieces/king'

describe King do

  describe '#possible_moves' do

    context 'when in middle of board surround by empty spaces' do
      subject(:king_empty) { described_class.new(:white, board, [4, 4]) }
      let(:board) { double('board') }
      let(:piece) { double('piece', color: :null) }

      it 'returns correct 8 moves' do
        allow(board).to receive(:[]).and_return(piece)
        expected_result = [
          [4, 5],
          [5, 5],
          [5, 4],
          [5, 3],
          [4, 3],
          [3, 3],
          [3, 4],
          [3, 5]
        ]
        result = king_empty.possible_moves
        expect(result).to eq(expected_result)
      end
    end

    context 'when in corner surrounded by empty spaces' do
      subject(:king_empty_corner) { described_class.new(:white, board, [0, 0]) }
      let(:board) { double('board') }
      let(:piece) { double('piece', color: :null) }

      it 'returns correct 3 moves' do
        allow(board).to receive(:[]).and_return(piece)
        expected_result = [
          [0, 1],
          [1, 1],
          [1, 0]
        ]
        result = king_empty_corner.possible_moves
        expect(result).to eq(expected_result)
      end
    end

    context 'when in corner surrounded by white pieces' do
      subject(:king_empty_corner_white) { described_class.new(:white, board, [0, 0]) }
      let(:board) { double('board') }
      let(:piece) { double('piece', color: :white) }
  
      it 'returns no moves' do
        allow(board).to receive(:[]).and_return(piece)
        expected_result = []
        result = king_empty_corner_white.possible_moves
        expect(result).to eq(expected_result)
      end
    end

    context 'when in corner surrounded by black pieces' do
      subject(:king_empty_corner_black) { described_class.new(:white, board, [0, 0]) }
      let(:board) { double('board') }
      let(:piece) { double('piece', color: :black) }
    
      it 'returns correct 3 moves' do
        allow(board).to receive(:[]).and_return(piece)
        expected_result = [
          [0, 1],
          [1, 1],
          [1, 0]
        ]
        result = king_empty_corner_black.possible_moves
        expect(result).to eq(expected_result)
      end
    end

  end

end