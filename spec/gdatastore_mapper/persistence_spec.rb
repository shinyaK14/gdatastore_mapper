require "spec_helper"

RSpec.describe GdatastoreMapper::Persistence do

  let(:rowling) { Author.create(name: 'J. K. Rowling', email: 'rowling@example.com') }
  let(:book) { rowling.books.create(title: 'Harry Poter') }

  context 'instance methods' do
    it 'saves record' do
      book = Book.new(title: 'Harry Poter')
      expect(book.save).to be true
      expect(book.id).not_to be nil
      expect(book.title).to eq('Harry Poter')
    end

    it 'updates record' do
      book.update(title: 'Harry Poter2')
      expect(book.title).to eq('Harry Poter2')
    end

    it 'returns persistence' do
      expect(book.persisted?).to be true
    end

    it 'deletes record' do
      book
      expect{
        book.delete
      }.to change{ Book.count }.by(-1)
    end
  end

  context 'callbacks' do
    it 'executes before save' do
      author = Author.new(name: 'Shakespeare', email: 'william@example.com')
      expect(author.comment).to be_nil
      author.save
      expect(author.comment).to eq('before_save')
    end

    it 'executes before update' do
      expect(book.description).to be_nil
      book.update(title: 'Romeo and Juliet')
      expect(book.description).to eq('before_update')
    end
  end
end

