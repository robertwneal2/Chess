require_relative '../lib/pieces/rook'

describe Rook do
  
  describe '#possible_moves' do
    
    context 'when rook is in middle of empty board' do
      subject(:rook_empty) { described_class.new(:white, board, [4, 4]) }
      let(:board) { double('board') }
      let(:piece) { double('piece', color: :null) }

      it 'returns all possible moves' do
        allow(board).to receive(:[]).and_return(piece)
        expected_result = [[5, 5], [6, 6], [7, 7], [5, 3], [6, 2], [7, 1], 
        [3, 3], [2, 2], [1, 1], [0, 0], [3, 5], [2, 6], [1, 7]]
        result = rook_empty.possible_moves
        expect(result).to eq(expected_result)
      end
    end
  end
end