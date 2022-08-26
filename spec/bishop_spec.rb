require_relative '../lib/pieces/bishop'

describe Bishop do
  
  describe '#possible_moves' do
    
    context 'when bishop is in middle of empty board' do
      subject(:bishop_empty) { described_class.new(:white, [4, 4]) }
      let(:board) { double('board') }
      let(:piece) { double('piece', color: :null) }

      it 'returns all possible moves' do
        allow(board).to receive(:[]).and_return(piece)
        expected_result = [[5, 5], [6, 6], [7, 7], [5, 3], [6, 2], [7, 1], 
        [3, 3], [2, 2], [1, 1], [0, 0], [3, 5], [2, 6], [1, 7]]
        result = bishop_empty.possible_moves(board)
        expect(result).to eq(expected_result)
      end
    end
  end
end