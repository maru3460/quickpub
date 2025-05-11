# 要修正

# 詳細設計書

## 1. システム概要

QuickPub は、ユーザーが HTML や CSS、JavaScript のコードをテキストとして入力し、それを独自のサブドメイン上で公開できる Web アプリケーションです。個人開発を前提としたシンプルな設計で、スムーズな実装と拡張性を両立します。

### 1.1 主要機能

- ユーザー登録・認証
- サイト作成・管理
- コンテンツ（HTML/CSS/JS）の作成・編集・管理
- カスタムサブドメインでのサイト公開
- ブラウザ上でのコード編集（Web IDE）

### 1.2 技術スタック

- **バックエンド**: Ruby on Rails 7.x
- **データベース**: PostgreSQL
- **フロントエンド**: Hotwire (Turbo + Stimulus)
- **ホスティング**: Heroku
- **DNS**: サブドメインワイルドカード対応の DNS サービス

## 2. データモデル設計

### 2.1 データベーススキーマ

#### Users テーブル

```ruby
create_table :users do |t|
  t.string :email, null: false
  t.string :encrypted_password, null: false
  t.string :username, null: false
  t.timestamps
end

add_index :users, :email, unique: true
add_index :users, :username, unique: true
```

#### Sites テーブル

```ruby
create_table :sites do |t|
  t.string :name, null: false
  t.string :subdomain, null: false
  t.text :description
  t.references :user, null: false, foreign_key: true
  t.timestamps
end

add_index :sites, :subdomain, unique: true
```

#### Contents テーブル (HTML/CSS/JS/その他ファイル)

```ruby
create_table :contents do |t|
  t.string :path, null: false     # "index.html", "style.css", etc.
  t.text :content                 # ファイル内容
  t.boolean :is_index, default: false  # インデックスページかどうか
  t.references :site, null: false, foreign_key: true
  t.timestamps
end

# 同じサイト内でパスの一意性を保証
add_index :contents, [:site_id, :path], unique: true
```

### 2.2 モデル関連

#### User モデル

```ruby
class User < ApplicationRecord
  # 認証関連（Devise等）
  has_many :sites, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true,
            format: { with: /\A[a-z0-9_\-]+\z/, message: "は英小文字、数字、アンダースコア、ハイフンのみ使用可能です" }
end
```

#### Site モデル

```ruby
class Site < ApplicationRecord
  belongs_to :user
  has_many :contents, dependent: :destroy

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true,
            format: { with: /\A[a-z0-9\-]+\z/, message: "は英小文字、数字、ハイフンのみ使用可能です" }

  # インデックスページを取得するヘルパーメソッド
  def index_page
    contents.find_by(is_index: true) || contents.find_by(path: "index.html")
  end
end
```

#### Content モデル

```ruby
class Content < ApplicationRecord
  belongs_to :site

  validates :path, presence: true
  validates :content, presence: true

  # 同じサイト内でパスの重複を防ぐ
  validates :path, uniqueness: { scope: :site_id }

  # インデックスページは1サイトにつき1つだけ
  validate :validate_only_one_index_per_site, if: -> { is_index? }

  private

  def validate_only_one_index_per_site
    if site.contents.where(is_index: true).where.not(id: id).exists?
      errors.add(:is_index, "インデックスページは1サイトにつき1つだけです")
    end
  end
end
```

## 3. ルーティングとコントローラー設計

### 3.1 ルーティング設計

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # 認証関連
  devise_for :users

  # 管理画面
  namespace :dashboard do
    resources :sites do
      resources :contents
    end
    root to: "sites#index"
  end

  # 公開サイト表示
  constraints(subdomain: /.+/) do
    get "/", to: "sites#index"
    get "/*path", to: "sites#show"
  end

  # メインサイト
  root to: "home#index"
end
```

### 3.2 コントローラー設計

#### SitesController

```ruby
class SitesController < ApplicationController
  def index
    @site = Site.find_by(subdomain: request.subdomain)
    if @site
      index_content = @site.index_page
      if index_content
        render html: index_content.content.html_safe, content_type: "text/html"
      else
        render plain: "404 Not Found - Index page not found", status: :not_found
      end
    else
      render plain: "404 Not Found - Site not found", status: :not_found
    end
  end

  def show
    @site = Site.find_by(subdomain: request.subdomain)
    if @site
      path = params[:path]
      content = @site.contents.find_by(path: path)

      if content
        content_type = get_content_type(path)
        render plain: content.content, content_type: content_type
      else
        render plain: "404 Not Found - Content not found", status: :not_found
      end
    else
      render plain: "404 Not Found - Site not found", status: :not_found
    end
  end

  private

  def get_content_type(path)
    extension = File.extname(path).downcase
    case extension
    when ".html", ".htm"
      "text/html"
    when ".css"
      "text/css"
    when ".js"
      "application/javascript"
    when ".json"
      "application/json"
    when ".jpg", ".jpeg"
      "image/jpeg"
    when ".png"
      "image/png"
    when ".gif"
      "image/gif"
    when ".svg"
      "image/svg+xml"
    else
      "text/plain"
    end
  end
end
```

#### Dashboard::SitesController

```ruby
class Dashboard::SitesController < DashboardController
  before_action :set_site, only: [:show, :edit, :update, :destroy]

  def index
    @sites = current_user.sites
  end

  def show
    @contents = @site.contents
  end

  def new
    @site = current_user.sites.new
  end

  def create
    @site = current_user.sites.new(site_params)
    if @site.save
      redirect_to dashboard_site_path(@site), notice: "サイトが正常に作成されました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @site.update(site_params)
      redirect_to dashboard_site_path(@site), notice: "サイトが正常に更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @site.destroy
    redirect_to dashboard_sites_path, notice: "サイトが正常に削除されました。"
  end

  private

  def set_site
    @site = current_user.sites.find(params[:id])
  end

  def site_params
    params.require(:site).permit(:name, :subdomain, :description)
  end
end
```

#### Dashboard::ContentsController

```ruby
class Dashboard::ContentsController < DashboardController
  before_action :set_site
  before_action :set_content, only: [:show, :edit, :update, :destroy]

  def index
    @contents = @site.contents
  end

  def show
  end

  def new
    @content = @site.contents.new
  end

  def create
    @content = @site.contents.new(content_params)
    if @content.save
      redirect_to dashboard_site_content_path(@site, @content), notice: "コンテンツが正常に作成されました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @content.update(content_params)
      redirect_to dashboard_site_content_path(@site, @content), notice: "コンテンツが正常に更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @content.destroy
    redirect_to dashboard_site_contents_path(@site), notice: "コンテンツが正常に削除されました。"
  end

  private

  def set_site
    @site = current_user.sites.find(params[:site_id])
  end

  def set_content
    @content = @site.contents.find(params[:id])
  end

  def content_params
    params.require(:content).permit(:path, :content, :is_index)
  end
end
```

## 4. UI/UX の設計

### 4.1 管理画面

- **サイト一覧**: ユーザーの全サイトを表示
- **サイト詳細**: サイト情報と含まれるコンテンツの一覧
- **コンテンツ編集**: Web IDE 機能を備えたエディター
  - シンタックスハイライト
  - リアルタイムプレビュー
  - ファイル保存機能

### 4.2 Web IDE 機能

Web IDE は以下の機能を提供します：

- コードのシンタックスハイライト（ACE Editor または CodeMirror）
- ファイルツリー表示
- プレビュー機能
- 基本的なショートカットキー

```javascript
// Web IDE初期化の例（CodeMirrorを使用）
document.addEventListener("turbo:load", function () {
  const editorElement = document.getElementById("editor");
  if (editorElement) {
    const editor = CodeMirror.fromTextArea(editorElement, {
      lineNumbers: true,
      mode: getModeForPath(
        document.querySelector('input[name="content[path]"]').value
      ),
      theme: "monokai",
      indentUnit: 2,
      autoCloseBrackets: true,
    });

    // パス入力に応じてモード（言語）を切り替える
    document
      .querySelector('input[name="content[path]"]')
      .addEventListener("change", function (e) {
        editor.setOption("mode", getModeForPath(e.target.value));
      });

    // フォーム送信時にエディタの内容をテキストエリアに反映
    document.querySelector("form").addEventListener("submit", function () {
      editor.save();
    });
  }
});

// ファイルパスから適切なモードを判定
function getModeForPath(path) {
  const extension = path.split(".").pop().toLowerCase();
  switch (extension) {
    case "html":
      return "htmlmixed";
    case "css":
      return "css";
    case "js":
      return "javascript";
    case "json":
      return "application/json";
    case "md":
      return "markdown";
    default:
      return "text/plain";
  }
}
```

## 5. インフラストラクチャ設計

### 5.1 本番環境

- **アプリケーションサーバー**: Heroku
- **データベース**: Heroku Postgres
- **DNS サービス**: Route 53（ワイルドカードサブドメイン対応）

### 5.2 サブドメイン設定

1. DNS プロバイダーでワイルドカードレコードを設定:

   ```
   *.yourdomain.com. CNAME yourapplication.herokuapp.com.
   ```

2. Heroku の設定:
   ```bash
   heroku domains:add *.yourdomain.com
   ```

### 5.3 パフォーマンス最適化

初期段階では単純な構成でスタートし、後々以下の最適化を検討:

1. **CDN 導入**: CloudFlare 等を使用して静的コンテンツをキャッシュ
2. **コンテンツキャッシュ**: サイトコンテンツを Redis などでキャッシュ
3. **インメモリキャッシュ**: 頻繁にアクセスされるサイトのメモリキャッシュ

## 6. セキュリティ対策

### 6.1 入力検証

- HTML コンテンツに対する XSS 対策:
  - ユーザー自身のサイト内での XSS は機能として許容する
  - 管理画面では適切にエスケープ処理を行う

### 6.2 認証・認可

- devise を使用した堅牢な認証システム
- サイトとコンテンツへのアクセス制御（所有者のみ編集可能）

### 6.3 レートリミット

- 公開サイトへのアクセスにレートリミットを適用
- API リクエストに対するレートリミット

## 7. 拡張計画

### 7.1 短期的な拡張計画

- マークダウンサポート
- テンプレート機能
- 複数ユーザーでの共同編集

### 7.2 中長期的な拡張計画

- カスタムドメイン対応
- コメント機能
- バージョン管理
- アナリティクス機能

## 8. デプロイメントとテスト戦略

### 8.1 デプロイメントパイプライン

1. GitHub へのプッシュ
2. GitHub Actions による自動テスト
3. テスト成功時、Heroku への自動デプロイ

### 8.2 テスト戦略

- モデルのユニットテスト
- コントローラーのリクエストテスト
- 統合テスト（サブドメインアクセスなど）
- システムテスト（UI 操作）

## 9. リファレンス実装

### モデル作成

```bash
rails g model User email:string username:string encrypted_password:string
rails g model Site name:string subdomain:string description:text user:references
rails g model Content path:string content:text is_index:boolean site:references
```

### マイグレーション例

```ruby
class AddIndexesToTables < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :sites, :subdomain, unique: true
    add_index :contents, [:site_id, :path], unique: true
  end
end
```

### コントローラー生成

```bash
rails g controller Sites index show
rails g controller Dashboard::Sites index show new create edit update destroy
rails g controller Dashboard::Contents index show new create edit update destroy
```

この設計を元に、シンプルながらも拡張性のある個人用サイト公開プラットフォームを構築できます。
