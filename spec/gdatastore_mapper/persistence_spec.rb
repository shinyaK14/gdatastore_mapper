require "spec_helper"

RSpec.describe GdatastoreMapper::Persistence do

  before do
    allow(Rails).to receive(:application).and_return(ConfigMock)
  end

  context 'save' do
    it 'saves record' do
      book = Book.new(title: 'GdatastoreMapper')
      expect(book.save).to be true
      expect(book.id).not_to be nil
      expect(book.title).to eq('GdatastoreMapper')
      expect(book.destroy).to be true
    end

  end
end

