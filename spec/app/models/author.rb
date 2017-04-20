class Author
  include GdatastoreMapper::Base

  attr_accessor :name, :comment

  has_many :books

  before_save :set_before_save

  private

  def set_before_save
    self.comment = 'before_save'
  end

end
