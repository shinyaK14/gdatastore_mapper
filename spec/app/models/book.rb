class Book
  include GdatastoreMapper::Base

  attr_accessor :title, :description

  belongs_to :author

  before_update :set_before_update

  private

  def set_before_update
    self.description = 'before_update'
  end

end
