require "spec_helper"

RSpec.describe GdatastoreMapper::Persistence do

  before do
    allow(Rails).to receive(:application).and_return(ConfigMock)
  end

  context 'save' do
    it 'saves record' do
      book = Book.new(title: 'Harry Poter')
      expect(book.save).to be true
      expect(book.id).not_to be nil
      expect(book.title).to eq('Harry Poter')
      expect(book.destroy).to be true
    end

    it 'updates record' do
      book = Book.last
      book.update(title: 'Harry Poter2')
      expect(book.title).to eq('Harry Poter2')
    end

    it 'returns persistence' do
      expect(Book.last.persisted?).to be true
    end

    it 'deletes record' do
      expect{
        Book.last.delete
      }.to change(Book, :count).by(-1)
    end

  end
end

