# Implements the main functionality with encrypt and decrypt methods.
# Works only with JSON format. Response object consists of :data and
# :frequency members. :data member can represent both - plain and
# encrypted text. :frequency member keeps an analysis data, in fact
# it's a nested hash object, where key => pair values are text character
# and an amount of this char in a text. Depending on the controller
# the data in a response object differs. A response from the encrypt
# action would contain the encrypted text and it's frequency analysis.
# Decrypt action, in turn, would the opposite data.
class CryptController < ApplicationController
  def index
  end

  def encrypt
    respond_to do |format|
      format.json { render json: Text.process_data(:encrypt, crypt_params) }
    end
  end
 
  def decrypt
    respond_to do |format|
      format.json { render json: Text.process_data(:decrypt, crypt_params) }
    end
  end

  private

  def crypt_params
    params.require(:crypt).permit(:text, :shift)
  end
end
