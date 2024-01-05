require 'rails_helper'

RSpec.describe SearchLog, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:query) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

end
