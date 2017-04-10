require "spec_helper"

RSpec.describe GdatastoreMapper do

  before do
    allow(Rails).to receive(:application).and_return(ConfigMock)
  end

end

