require "spec_helper"

RSpec.describe GdatastoreMapper do

  before do
    allow(Rails).to receive(:application).and_return(ConfigMock)
  end

  it 'creates record if params is valid' do
    book = Book.create(title: 'Harry Potter')
    expect(book.id).to be_kind_of(Fixnum)
    expect(book.title).to eq('Harry Potter')
  end

end

