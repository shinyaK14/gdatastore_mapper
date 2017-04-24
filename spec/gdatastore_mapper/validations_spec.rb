require "spec_helper"

RSpec.describe GdatastoreMapper::Validations do

  let!(:rowling) { Author.create(name: 'J. K. Rowling', email: 'rowling@example.com') }

  context 'presence' do
    it 'returns error' do
      author = Author.new
      expect(author.valid?).to be false
      expect(author.errors[:email]).to include("can't be blank")
    end
  end

  context 'format' do
    it 'returns error' do
      author = Author.new(email: '123123123')
      expect(author.valid?).to be false
      expect(author.errors[:email]).to eq(['is invalid'])
    end
  end

  context 'length' do
    it 'returns error' do
      author = Author.new(email: '123123123123123123123@example.com')
      expect(author.valid?).to be false
      expect(author.errors[:email]).to eq(['is too long (maximum is 20 characters)'])
    end
  end

  context 'uniqueness' do
    it 'returns error' do
      author = Author.new(email: rowling.email)
      expect(author.valid?).to be false
      expect(author.errors[:email]).to eq(['has already been taken'])
    end
  end

  it 'creates record if params is valid' do
    expect(rowling.id).not_to be nil
  end
end
