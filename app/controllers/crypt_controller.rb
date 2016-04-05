class CryptController < ApplicationController
  before_action :set_crypt_vars

  def encrypt
    output= @text.split('').inject('') do |memo, char|
      ind = @alphabet.index(char) || 0 # If someone uses another but english layout
      memo + @rot_alphabet[ind]
    end

    respond_to do |format|
      format.json { render json: {plain: @text, encrypted: output, frequency: frequency_analisys(output)}, status: :ok }
    end
  end
 
  def decrypt
    output= @text.split('').inject('') do |memo, char|
      ind = @rot_alphabet.index(char) || 0
      memo + @alphabet[ind]
    end  

    respond_to do |format|
      format.json { render json: {plain: output, encrypted: @text, frequency: frequency_analisys(output)}, status: :ok }
    end
  end

  private
  def frequency_analisys(input_text)
    input_text.split('').group_by{|x| x}.inject([]) do |memo, i|
      memo << [i[0], i[1].length]
    end
  end

  def set_crypt_vars
    @text, shifted_range = crypt_params.values_at(:text, :shift)
    @text ||= ''
    @alphabet = Text.english_alphabet
    @alph_length = @alphabet.length
    @rot_alphabet = @alphabet.rotate(shifted_range.to_i)
  end

  def crypt_params
    params.require(:crypt).permit(:text, :shift)
  end
end
