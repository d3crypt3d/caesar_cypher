class Text < ActiveRecord::Base
  validates_presence_of :alphabet, :lang

  def self.english_alphabet
    (32..126).map {|i| i.chr}
  end
end
