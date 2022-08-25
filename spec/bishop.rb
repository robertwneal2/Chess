require_relative '../lib/pieces/bishop'

describe Bishop do
  
  describe '#possible_moves' do
    
    context 'when bishop is in middle of empty board' do
      subject(:bishop_empty) { described_class.new(:white, board, [4, 4]) }
      let(:board) { double('board') }
      let(:piece) { double('piece', color: :null) }

      it 'returns all possible moves' do
        allow(board).to receive(:[]).and_return(piece)
        expected_result = [[4, 5], [4, 6], [4, 7], [4, 3], [4, 2], [4, 1], 
        [4, 0], [5, 4], [6, 4], [7, 4], [3, 4], [2, 4], [1, 4], [0, 4]]
        result = bishop_empty.possible_moves
        expect(result).to eq(expected_result)
      end
    end
  end
end