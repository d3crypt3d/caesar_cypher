class CryptController < ApplicationController
  before_action :set_crypt_vars
  respond_to :json

  def encrypt
    output= @text.split('').inject('') do |memo, char|
      ind = @alphabet.index(char)
      memo + @rot_alphabet[ind]
    end
    
    render json: {plain: @text, encrypted: output}, status: :ok
  end
 
  def decrypt
    output= @text.split('').inject('') do |memo, char|
      ind = @rot_alphabet.index(char)
      memo + @alphabet[ind]
    end  

    render json: {plain: output, encrypted: @text}, status: :ok
  end

  private
  def set_crypt_vars
    @text, shifted_range = crypt_params.values_at(:text, :shift)
    @alphabet = Text.english_alphabet
    @alph_length = @alphabet.length
    @rot_alphabet = @alphabet.rotate(shifted_range.to_i)
  end

  def crypt_params
    params.require(:crypt).permit(:text, :shift)
  end
end
