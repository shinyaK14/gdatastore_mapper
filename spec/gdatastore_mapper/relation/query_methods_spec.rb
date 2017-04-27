require "spec_helper"

RSpec.describe GdatastoreMapper::QueryMethods do

  let!(:rowling) { Author.create(name: 'J. K. Rowling', email: 'rowling@example.com') }
  let!(:book1) { rowling.books.create(title: 'Harry Potter 1') }
  let!(:book2) { rowling.books.create(title: 'Harry Potter 2') }
  let!(:book3) { rowling.books.create(title: 'Harry Potter 3') }

  context 'order' do
    it 'returns relation as result of order' do
      result = rowling.books.order(created_at: :asc).order(title: :desc)
      expect(result).to be_kind_of(GdatastoreMapper::Relation)
      expect(result.first.id).to eq(book3.id)
    end
  end

  context 'where' do
    it 'returns relation as result of where' do
      result = rowling.books.where(author_id: rowling.id).where(title: book2.title)
      expect(result).to be_kind_of(GdatastoreMapper::Relation)
      expect(result.first.id).to eq(book2.id)
    end
  end

  context 'find' do
    it 'returns instance as result of find' do
      result = rowling.books.where(author_id: rowling.id).find(book2.id)
      expect(result).to be_kind_of(Book)
      expect(result.id).to eq(book2.id)
    end
  end

  context 'find_by' do
    it 'returns instance as result of find_by' do
      result = rowling.books.where(author_id: rowling.id).find_by(title: book3.title)
      expect(result).to be_kind_of(Book)
      expect(result.id).to eq(book3.id)
    end
  end

  context 'find_or_create' do
    it 'returns record as result of find if there is a record' do
      result = rowling.books.where(author_id: rowling.id).find_or_create(title: book3.title)
      expect(result).to be_kind_of(Book)
      expect(result.id).to eq(book3.id)
    end

    it 'returns record as result of create if there is no record' do
      result = rowling.books.where(author_id: rowling.id).find_or_create(title: 'Harry Potter 4')
      expect(result).to be_kind_of(Book)
      expect(result.title).to eq('Harry Potter 4')
    end
  end

  it 'returns first record' do
    result = rowling.books.order(title: :asc).first
    expect(result).to be_kind_of(Book)
    expect(result.id).to eq(book1.id)
  end

  it 'returns last record' do
    result = rowling.books.order(title: :asc).last
    expect(result).to be_kind_of(Book)
    expect(result.id).to eq(book3.id)
  end

  it 'returns number of records' do
    expect(rowling.books.order(title: :asc).count).to eq(3)
  end

  context 'limit' do
    it 'returns relation as result of limit' do
      result = rowling.books.order(title: :asc).limit(2)
      expect(result).to be_kind_of(GdatastoreMapper::Relation)
      expect(result.count).to eq(2)
    end
  end
end
