require "spec_helper"

RSpec.describe GdatastoreMapper::Scoping do

  before do
    allow(Rails).to receive(:application).and_return(ConfigMock)
  end

  context 'where' do
    it 'returns results' do
      Book.create(title: 'Harry Poter')
      result = Book.where(title: 'Harry Poter')
      expect(result).to be_kind_of(GdatastoreMapper::Relation)
      expect(result.first).to be_kind_of(Book)
      expect(result.last.title).to eq('Harry Poter')
    end

    it 'returns nil if condition is invalid' do
      expect(Book.where(123)).to be_nil
    end
  end

  context 'find' do
    it 'returns record' do
      book = Book.last
      expect(Book.find(book.id).id).to eq(book.id)
    end

    it 'returns nil if condition is invalid' do
      expect(Book.find('a')).to be_nil
    end
  end

  context 'find_by' do
    it 'returns record' do
      book = Book.first
      expect(Book.find_by(title: book.title).id).to eq(book.id)
    end

    it 'returns nil if condition is invalid' do
      expect(Book.find_by('a')).to be_nil
    end
  end

  context 'order' do
    it 'returns results' do
      result = Book.order(updated_at: :desc)
      expect(result).to be_kind_of(GdatastoreMapper::Relation)
      expect(result.first).to be_kind_of(Book)
      # expect(result.first.updated_at).to be_more_than(result.last.updated_at)
    end
  end
end


