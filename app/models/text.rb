# Text is a non-ActiveRecord model (inclides ActiveAttr
# mixin). It keeps all the business logic to perform both
# encryption and decryption transformations. CHAR_TABLE
# constant keeps a piece of unicode char table with latin
# letters, numbers and punctuation marks:
#
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
#
# The factory method is used to instantiate data objects
# with processed text and supplemental frequency analysis.
class Text
  include ActiveAttr::Model

  CHAR_TABLE = (32..126).map(&:chr)

  attribute :data
  attribute :frequency

  def self.process_data(action, input_params)
    text, shifted_range = input_params.values_at(:text, :shift)
    text ||= ''
    rot_table = CHAR_TABLE.rotate(shifted_range.to_i)
    splitted_text = text.split('')

    output = case action
             when :encrypt
               splitted_text.inject('') do |memo, char|
                 # If someone uses another but english layout
                 # the character would not be found in a table
                 # 0 is a fallback
                 ind = CHAR_TABLE.index(char) || 0
                 memo + rot_table[ind]
               end
             when :decrypt
               splitted_text.inject('') do |memo, char|
                 ind = rot_table.index(char) || 0
                 memo + CHAR_TABLE[ind]
               end
             end

    new(data: output, frequency: frequency_analisys(output))
  end

  def self.frequency_analisys(input_text)
    input_text.split('').group_by { |x| x }.inject([]) do |memo, i|
      memo << [i[0], i[1].length]
    end
  end

  private_class_method :new, :frequency_analisys
end
