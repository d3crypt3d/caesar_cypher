RSpec.shared_context 'shared_lets' do
  let(:example) { { 'crypt' => { 'text' => 'Lorem epsum', 'shift' => 4 } } }
  let(:proper_response) { 'Psviq$itwyq' }
  let(:plain_example) { example['crypt']['text'] }
  let(:shift_num) { example['crypt']['shift'] }
end
