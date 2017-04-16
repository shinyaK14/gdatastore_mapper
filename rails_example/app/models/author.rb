class Author
  include GdatastoreMapper::Base

  attr_accessor :name

  has_many :books

  validates :name, presence: true

  def delete_books
    books.each do |book|
      book.delete
    end
  end
end
