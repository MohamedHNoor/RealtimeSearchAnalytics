require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'scopes' do
    describe '.filter_by_name' do
      let!(:article1) { create(:article, name: 'Example Article 1') }
      let!(:article2) { create(:article, name: 'Example Article 2') }
      let!(:article3) { create(:article, name: 'Another Article') }

      it 'returns articles matching the provided name' do
        filtered_articles = Article.filter_by_name('Example')

        expect(filtered_articles).to include(article1)
        expect(filtered_articles).to include(article2)
        expect(filtered_articles).not_to include(article3)
      end

      it 'is case-insensitive' do
        filtered_articles = Article.filter_by_name('example')

        expect(filtered_articles).to include(article1)
        expect(filtered_articles).to include(article2)
        expect(filtered_articles).not_to include(article3)
      end
    end
  end
end
