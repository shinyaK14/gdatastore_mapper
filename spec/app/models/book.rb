class Book
  include GdatastoreMapper::Base

  attr_accessor :title

  belongs_to :author

end
