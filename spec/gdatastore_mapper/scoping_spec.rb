require "spec_helper"

RSpec.describe GdatastoreMapper::Scoping do

  let!(:rowling) { Author.create(name: 'J. K. Rowling') }
  let!(:book) { rowling.books.create(title: 'Harry Poter') }

  context 'where' do
    it 'returns results' do
      result = Book.where(title: 'Harry Poter')
      expect(result).to be_kind_of(GdatastoreMapper::Relation)
      if result.count > 0
        expect(result.first).to be_kind_of(Book)
        expect(result.last.title).to eq('Harry Poter')
      end
    end

    it 'returns nil if condition is invalid' do
      expect(Book.where(123)).to be_nil
    end
  end

  context 'find' do
    it 'returns record' do
      expect(Book.find(book.id).id).to eq(book.id)
    end
  end

  context 'find_by' do
    it 'returns record' do
      expect(Book.find_by(title: book.title).title).to eq(book.title)
    end

    it 'returns nil if condition is invalid' do
      expect(Book.find_by('a')).to be_nil
    end
  end

  context 'find_or_create' do
    it 'returns record if it exists' do
      expect(Book.find_or_create(title: book.title).title).to eq(book.title)
    end

    it 'returns nil if condition is invalid' do
      expect(Book.find_or_create('a')).to be_nil
    end
  end

  context 'order' do
    it 'returns results' do
      result = Book.order(updated_at: :desc)
      expect(result).to be_kind_of(GdatastoreMapper::Relation)
      expect(result.first).to be_kind_of(Book)
      expect(result.first.updated_at).to be >= result.last.updated_at
    end
  end

  context 'all' do
    it 'returns results' do
      result = Book.all
      expect(result).to be_kind_of(GdatastoreMapper::Relation)
      expect(result.first).to be_kind_of(Book)
    end
  end

  context 'each' do
    it 'allows to pass block' do
      Book.each do |book|
        expect(book).to be_kind_of(Book)
      end
    end
  end

  context 'first' do
    it 'returns results' do
      result = Book.first
      expect(result).to be_kind_of(Book)
      expect(result.updated_at).to be <= Book.last.updated_at
    end
  end

  context 'count' do
    it 'returns results' do
      expect(Book.count).to be_kind_of(Fixnum)
    end
  end
end


