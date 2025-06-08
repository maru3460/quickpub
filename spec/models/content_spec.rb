require 'rails_helper'

RSpec.describe Content, type: :model do
  describe 'バリデーション' do
    let(:content) { build(:content) }

    it '有効なファクトリを持つこと' do
      expect(content).to be_valid
    end

    it 'pathが必須であること' do
      content.path = nil
      expect(content).not_to be_valid
      expect(content.errors[:path]).to include("can't be blank")
    end

    it 'contentが必須であること' do
      content.content = nil
      expect(content).not_to be_valid
      expect(content.errors[:content]).to include("can't be blank")
    end

    it 'site_idが必須であること' do
      content.site = nil
      expect(content).not_to be_valid
      expect(content.errors[:site]).to include("must exist")
    end
  end

  describe 'アソシエーション' do
    let(:site) { create(:site) }
    let(:content) { create(:content, site: site) }

    it 'siteに属すること' do
      expect(content.site).to eq(site)
    end
  end
end
