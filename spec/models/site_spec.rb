require 'rails_helper'

RSpec.describe Site, type: :model do
  describe 'バリデーション' do
    let(:site) { build(:site) }

    it '有効なファクトリを持つこと' do
      expect(site).to be_valid
    end

    it 'nameが必須であること' do
      site.name = nil
      expect(site).not_to be_valid
      expect(site.errors[:name]).to include("can't be blank")
    end

    it 'subdomainが必須であること' do
      site.subdomain = nil
      expect(site).not_to be_valid
      expect(site.errors[:subdomain]).to include("can't be blank")
    end

    it 'subdomainがユニークであること' do
      create(:site, subdomain: 'test-subdomain')
      site.subdomain = 'test-subdomain'
      expect(site).not_to be_valid
      expect(site.errors[:subdomain]).to include("has already been taken")
    end

    it 'subdomainが英数字とハイフンのみであること' do
      site.subdomain = 'test_subdomain!'
      expect(site).not_to be_valid
      expect(site.errors[:subdomain]).to include("は英数字とハイフンのみ使用可能です")
    end

    it '有効なsubdomainの形式であること' do
      valid_subdomains = [ 'test', 'test123', 'test-123', 'TEST' ]
      valid_subdomains.each do |subdomain|
        site.subdomain = subdomain
        expect(site).to be_valid, "#{subdomain} should be valid"
      end
    end
  end

  describe 'アソシエーション' do
    let(:site) { create(:site) }

    it 'contentsを持つこと' do
      content = create(:content, site: site)
      expect(site.contents).to include(content)
    end

    it 'サイトが削除されるとcontentsも削除されること' do
      content = create(:content, site: site)
      expect { site.destroy }.to change { Content.count }.by(-1)
    end
  end
end
