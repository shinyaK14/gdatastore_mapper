require "spec_helper"

RSpec.describe GdatastoreMapper::Persistence::ClassMethods do

  before do
    allow(Rails).to receive(:application).and_return(ConfigMock)
  end

  context 'create' do
    it 'saves record' do
      book = Book.create(title: 'Harry Poter 4')
      expect(book.id).not_to be nil
      expect(book.title).to eq('Harry Poter 4')
    end
  end

  context 'delete_all' do
    it 'deletes all records' do
      expect(Book.delete_all).to be true
      sleep 1
      expect(Book.count).to eq 0
    end
  end
end
