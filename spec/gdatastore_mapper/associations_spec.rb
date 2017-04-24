require "spec_helper"

RSpec.describe GdatastoreMapper::Associations do

  let(:rowling) { Author.create(name: 'J. K. Rowling', email: 'rowling@example.com') }
  let(:harry_poter) { rowling.books.create(title: 'Harry Poter') }
  let(:harry_poter2) { rowling.books.create(title: 'Harry Poter 2') }

  context 'has_many' do
    it 'creates one to many relationship' do
      expect(harry_poter.author.id).to eq(rowling.id)
      expect(harry_poter2.author.id).to eq(rowling.id)
      expect(rowling.books.count).to eq 2
      expect(rowling.books.first).to be_kind_of(Book)
    end
  end
end


