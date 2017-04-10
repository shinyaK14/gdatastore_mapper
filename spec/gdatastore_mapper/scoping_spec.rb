require "spec_helper"

RSpec.describe GdatastoreMapper::Scoping do

  before do
    allow(Rails).to receive(:application).and_return(ConfigMock)
  end

  context 'where' do
    it 'returns array' do
      result = Book.where(title: 'aaa')
      expect(result).to be_kind_of(Array)
      expect(result.first).to be_kind_of(Book)
      expect(result.last.title).to eq('aaa')
    end

    it 'returns nil if condition is invalid' do
      expect(Book.where(123)).to be_nil
    end
  end

end


