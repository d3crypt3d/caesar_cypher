RSpec.shared_context 'shared_lets' do
  let(:example) { { 'crypt' => { 'text' => 'lorem epsum', 'shift' => 4 } } }
  let(:proper_response) { 'psviq itwyq' }
  let(:plain_example) { example['crypt']['text'] }
  let(:shift_num) { example['crypt']['shift'] }
end
