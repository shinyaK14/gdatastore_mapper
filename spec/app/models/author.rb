class Author
  include GdatastoreMapper::Base

  attr_accessor :name

  has_many :books

end
