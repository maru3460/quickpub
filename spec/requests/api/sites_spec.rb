require 'rails_helper'

RSpec.describe 'Api::Sites', type: :request do
  describe 'GET /api/sites' do
    let!(:sites) { create_list(:site, 3) }
    
    it 'サイト一覧を取得できること' do
      get '/api/sites'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
  
  describe 'GET /api/sites/:id' do
    let(:site) { create(:site) }
    
    it '指定されたサイトを取得できること' do
      get "/api/sites/#{site.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['name']).to eq(site.name)
      expect(json['subdomain']).to eq(site.subdomain)
    end
    
    it '存在しないサイトの場合404を返すこと' do
      get '/api/sites/999999'
      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Site not found')
    end
  end
  
  describe 'POST /api/sites' do
    let(:valid_params) do
      {
        site: {
          name: 'テストサイト',
          description: 'テスト用のサイトです',
          subdomain: 'test-site'
        }
      }
    end
    
    it '有効なパラメータでサイトを作成できること' do
      expect {
        post '/api/sites', params: valid_params
      }.to change(Site, :count).by(1)
      
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['name']).to eq('テストサイト')
      expect(json['subdomain']).to eq('test-site')
    end
    
    it '無効なパラメータの場合エラーを返すこと' do
      invalid_params = { site: { name: '', subdomain: '' } }
      
      post '/api/sites', params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to be_present
    end
  end
  
  describe 'PATCH /api/sites/:id' do
    let(:site) { create(:site) }
    let(:update_params) do
      {
        site: {
          name: '更新されたサイト名',
          description: '更新された説明'
        }
      }
    end
    
    it 'サイトを更新できること' do
      patch "/api/sites/#{site.id}", params: update_params
      expect(response).to have_http_status(:ok)
      
      site.reload
      expect(site.name).to eq('更新されたサイト名')
      expect(site.description).to eq('更新された説明')
    end
    
    it '無効なパラメータの場合エラーを返すこと' do
      invalid_params = { site: { name: '' } }
      
      patch "/api/sites/#{site.id}", params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to be_present
    end
  end
  
  describe 'DELETE /api/sites/:id' do
    let!(:site) { create(:site) }
    
    it 'サイトを削除できること' do
      expect {
        delete "/api/sites/#{site.id}"
      }.to change(Site, :count).by(-1)
      
      expect(response).to have_http_status(:no_content)
    end
  end
end