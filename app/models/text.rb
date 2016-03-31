class Text < ActiveRecord::Base
  validates_presence_of :alphabet, :shift
end
