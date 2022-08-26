require_relative '../lib/pieces/rook'

describe Rook do
  
  describe '#possible_moves' do
    
    context 'when rook is in middle of empty board' do
      subject(:rook_empty) { described_class.new(:white, [4, 4]) }
      let(:board) { double('board') }
      let(:piece) { double('piece', color: :null) }

      it 'returns all possible moves' do
        allow(board).to receive(:[]).and_return(piece)
        expected_result = [[4, 5], [4, 6], [4, 7], [4, 3], [4, 2], [4, 1], 
        [4, 0], [5, 4], [6, 4], [7, 4], [3, 4], [2, 4], [1, 4], [0, 4]]
        result = rook_empty.possible_moves(board)
        expect(result).to eq(expected_result)
      end
    end
  end
end