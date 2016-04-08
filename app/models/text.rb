# Text is a non-ActiveRecord model (inclides ActiveAttr
# mixin). It keeps all the business logic to perform both
# encryption and decryption transformations. CHAR_TABLE
# constant keeps a piece of unicode char table with latin
# letters:
#
#  ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
#   "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
#   "u", "v", "w", "x", "y", "z"]
#
# The factory method is used to instantiate data objects
# with processed text and supplemental frequency analysis.
class Text
  include ActiveAttr::Model

  CHAR_TABLE = (97..122).map(&:chr)

  attribute :data
  attribute :frequency

  def self.process_data(action, input_params)
    text, shifted_range = input_params.values_at(:text, :shift)
    text ||= ''
    rot_table = CHAR_TABLE.rotate(shifted_range.to_i)
    # remain only letters and spaces, remove numbers
    # and punctuation marks
    splitted_text = text.downcase.gsub(/[^a-z\s]/,'').split('')

    output = case action
             when :encrypt
               splitted_text.inject('') do |memo, char|
                 result = if char == ' '
                            char
                          else
                            # If someone uses another but english layout
                            # the character would not be found in a table
                            # 0 is a fallback
                            ind = CHAR_TABLE.index(char) || 0
                            rot_table[ind]
                          end
                 memo + result
               end
             when :decrypt
               splitted_text.inject('') do |memo, char|
                 result = if char == ' '
                            char
                          else
                            ind = rot_table.index(char) || 0
                            CHAR_TABLE[ind]
                          end
                 memo + result
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
