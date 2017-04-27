require "spec_helper"

RSpec.describe GdatastoreMapper::Relation do

  let(:rowling) { Author.create(name: 'J. K. Rowling', email: 'rowling@example.com') }

  context 'new, save' do
    it 'new and saves record through relation' do
      book = rowling.books.new(title: 'Harry Poter 3')
      expect(book.author_id).to eq(rowling.id)
      expect(book.save).to be true
      expect(book.id).not_to be nil
      jkrowling = Author.find(rowling.id)
      expect(jkrowling.books.last.title).to eq(book.title)
    end

    it  'creates record' do
      book = rowling.books.create(title: 'Harry Poter 4')
      expect(book.author_id).to eq(rowling.id)
      expect(book.id).not_to be nil
      jkrowling = Author.find(rowling.id)
      expect(jkrowling.books.last.title).to eq(book.title)
    end

  end
end

