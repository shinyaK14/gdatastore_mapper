require "spec_helper"

RSpec.describe GdatastoreMapper::Persistence do

  before do
    allow(Rails).to receive(:application).and_return(ConfigMock)
  end

  context 'instance methods' do
    it 'saves record' do
      book = Book.new(title: 'Harry Poter')
      expect(book.save).to be true
      expect(book.id).not_to be nil
      expect(book.title).to eq('Harry Poter')
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
      }.to change{ Book.count }.by(-1)
    end
  end

  context 'callbacks' do
    it 'executes before save' do
      author = Author.new(name: 'Shakespeare')
      expect(author.comment).to be_nil
      author.save
      expect(author.comment).to eq('before_save')
      author.delete
    end

    it 'executes before update' do
      book = Book.create(title: 'Hamlet')
      expect(book.description).to be_nil
      book.update(title: 'Romeo and Juliet')
      expect(book.description).to eq('before_update')
      book.delete
    end
  end
end

