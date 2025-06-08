require 'rails_helper'

RSpec.describe 'Api::Contents', type: :request do
  let(:site) { create(:site) }

  describe 'GET /api/contents' do
    let!(:contents) { create_list(:content, 3, site: site) }
    let!(:other_contents) { create_list(:content, 2) }

    it 'コンテンツ一覧を取得できること' do
      get '/api/contents'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(5)
    end

    it 'site_idでフィルタできること' do
      get '/api/contents', params: { site_id: site.id }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(3)
      json.each do |content|
        expect(content['site_id']).to eq(site.id)
      end
    end
  end

  describe 'GET /api/contents/:id' do
    let(:content) { create(:content, site: site) }

    it '指定されたコンテンツを取得できること' do
      get "/api/contents/#{content.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['path']).to eq(content.path)
      expect(json['content']).to eq(content.content)
      expect(json['site_id']).to eq(site.id)
    end

    it '存在しないコンテンツの場合404を返すこと' do
      get '/api/contents/999999'
      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Content not found')
    end
  end

  describe 'POST /api/contents' do
    let(:valid_params) do
      {
        content: {
          site_id: site.id,
          path: 'index.html',
          content: '<html><body><h1>テストページ</h1></body></html>'
        }
      }
    end

    it '有効なパラメータでコンテンツを作成できること' do
      expect {
        post '/api/contents', params: valid_params
      }.to change(Content, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['path']).to eq('index.html')
      expect(json['site_id']).to eq(site.id)
    end

    it '無効なパラメータの場合エラーを返すこと' do
      invalid_params = { content: { path: '', content: '' } }

      post '/api/contents', params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to be_present
    end
  end

  describe 'PATCH /api/contents/:id' do
    let(:content) { create(:content, site: site) }
    let(:update_params) do
      {
        content: {
          path: 'updated.html',
          content: '<html><body><h1>更新されたページ</h1></body></html>'
        }
      }
    end

    it 'コンテンツを更新できること' do
      patch "/api/contents/#{content.id}", params: update_params
      expect(response).to have_http_status(:ok)

      content.reload
      expect(content.path).to eq('updated.html')
      expect(content.content).to eq('<html><body><h1>更新されたページ</h1></body></html>')
    end

    it '無効なパラメータの場合エラーを返すこと' do
      invalid_params = { content: { path: '' } }

      patch "/api/contents/#{content.id}", params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to be_present
    end
  end

  describe 'DELETE /api/contents/:id' do
    let!(:content) { create(:content, site: site) }

    it 'コンテンツを削除できること' do
      expect {
        delete "/api/contents/#{content.id}"
      }.to change(Content, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
