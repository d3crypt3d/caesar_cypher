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
    @rot_table = CHAR_TABLE.rotate(shifted_range.to_i)
    # remain only letters and spaces, remove numbers
    # and punctuation marks
    splitted_text = text.downcase.gsub(/[^a-z\s]/, '').split
    # Process word by word
    output = splitted_text.map do |i|
      # Process letter by letter
      i.split('').inject('',
                         &(action == :encrypt ? method(:encrypt) : method(:decrypt)))
    end

    output = output.join(' ')
    new(data: output, frequency: frequency_analisys(output))
  end

  def self.encrypt(m, i)
    # If someone uses another but english layout
    # the character would not be found in a table
    # 0 is a fallback
    ind = CHAR_TABLE.index(i) || 0
    m + @rot_table[ind]
  end

  def self.decrypt(m, i)
    ind = @rot_table.index(i) || 0
    m + CHAR_TABLE[ind]
  end

  def self.frequency_analisys(input_text)
    # Remove spaces - we don't need them on chart
    input_text.delete(' ').split('').group_by { |x| x }.inject([]) do |memo, i|
      memo << [i[0], i[1].length]
    end
  end

  private_class_method :new, :encrypt, :decrypt, :frequency_analisys
end
