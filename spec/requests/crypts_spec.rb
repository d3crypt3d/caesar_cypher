require 'rails_helper'

RSpec.describe 'Crypts' do
  include_context 'shared_lets'

  let(:proper_response_to_send) do
    # clone only duplicates the main object, inner object remains the same
    example.deep_dup.tap { |obj| obj['crypt']['text'] = proper_response }
  end

  subject { response }

  describe 'POST #encrypt' do
    context 'with valid attributes' do
      before { make_request :post, encrypt_path, example }

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }

      it 'properly encrypts a text' do
        expect(parse_for(:data)).to eq(proper_response)
      end
    end

    context 'with invalid attributes' do
      before do
        make_request(:post, encrypt_path,
                     example, mime_accept: Mime::XML)
      end

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end
  end

  describe 'POST #decrypt' do
    context 'with valid attributes' do
      before { make_request :post, decrypt_path, proper_response_to_send }

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }

      it 'properly decrypts a text' do
        expect(parse_for(:data)).to eq(plain_example)
      end
    end

    context 'with invalid attributes' do
      before do
        make_request(:post, decrypt_path,
                     proper_response_to_send,
                     mime_accept: Mime::XML)
      end

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end
  end
end
