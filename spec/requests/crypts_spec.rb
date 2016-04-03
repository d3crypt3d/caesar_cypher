require 'rails_helper'

RSpec.describe "Crypts", :type => :request do
  let(:example) { {'crypt'=> {'text'=> 'Lorem epsum', 'shift'=> 4}} }
  let(:proper_response) { 'Psviq$itwyq' }
  let(:proper_response_to_send) do
    # clone only duplicates the main object and leaves the inner object same
    example.deep_dup.tap {|obj| obj['crypt']['text']= proper_response}
  end
  let(:example_to_receive) { example['crypt']['text'] }
  # [" ", "!", "\"", "#", "$", "%", "&", "'", "(", ")",
  #  "*", "+", ",", "-", ".", "/", "0", "1", "2", "3",
  #  "4", "5", "6", "7", "8", "9", ":", ";", "<", "=",
  #  ">", "?", "@", "A", "B", "C", "D", "E", "F", "G",
  #  "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q",
  #  "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[",
  #  "\\", "]", "^", "_", "`", "a", "b", "c", "d", "e",
  #  "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
  #  "p", "q", "r", "s", "t", "u", "v", "w", "x", "y",
  #  "z", "{", "|", "}", "~"]
  subject { response }

  describe "POST #encrypt" do
    context 'with valid attributes' do
      before { make_request :post, encrypt_path, example }  

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }

      it "properly encrypts a text" do
        expect(parse_for(:encrypted)).to eq(proper_response)
      end
    end

    context 'with invalid attributes' do
      before { make_request :post, encrypt_path, example, mime_accept: Mime::XML }

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end
  end

  describe "POST #decrypt" do
    context 'with valid attributes' do
      before { make_request :post, decrypt_path, proper_response_to_send }  

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }

      it "properly decrypts a text" do
        expect(parse_for(:plain)).to eq(example_to_receive)
      end
    end

    context 'with invalid attributes' do
      before do
        make_request :post, decrypt_path, proper_response_to_send, mime_accept: Mime::XML
      end

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end
  end
end
