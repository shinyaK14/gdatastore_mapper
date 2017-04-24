class Author
  include GdatastoreMapper::Base

  attr_accessor :name, :comment, :email

  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :email, length: { in: 3..20 }
  validates_uniqueness_of :email

  has_many :books

  before_save :set_before_save

  private

  def set_before_save
    self.comment = 'before_save'
  end

end
