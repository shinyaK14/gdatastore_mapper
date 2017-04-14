require "spec_helper"

RSpec.describe GdatastoreMapper::Associations do

  before do
    allow(Rails).to receive(:application).and_return(ConfigMock)
  end

  context 'has_many' do
    it 'creates one to many relationship' do
      # j_k_rolling = Author.find_or_create(name: 'J K Rolling')
      # harry_poter = j_k_rolling.books.create(title: 'Harry Poter')
      # harry_poter_2 = j_k_rolling.books.create(title: 'Harry Poter 2')
      # expect(j_k_rolling.books.count).to eq 2
    end

    it 'returns records from owner' do
      j_k_rolling = Author.last
      expect(j_k_rolling.books.class).to eq(GdatastoreMapper::Relation)
      expect(j_k_rolling.books.first.class).to eq(Book)
    end

    it 'returns record from belongings' do
      j_k_rolling = Author.find_by(name: 'J K Rolling')
      book = Book.find_by(author_id: j_k_rolling.id)
      expect(book.author.class).to eq(Author)
    end
  end
end


