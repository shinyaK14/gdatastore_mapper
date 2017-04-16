class Book
  include GdatastoreMapper::Base

  attr_accessor :title, :description

  belongs_to :author

  validates :title, presence: true
end
