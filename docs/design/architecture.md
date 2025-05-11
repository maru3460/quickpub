# システムアーキテクチャ

## 全体構成

フロントエンド: ReactRouter
バックエンド: rails
DB: sqlite

## 技術スタック

### バックエンド

Ruby 3.4.3
Rails 8.0.2
rubocop
rspec
jwt

### フロントエンド

TypeScript
React
ReactRouter
ReactQuery
jotai
biome

### データベース

SQLite
Active Record

## コンポーネント

### バックエンド

あとで

#### コントローラー層

あとで

#### モデル層

あとで

#### サービス層

あとで

### フロントエンド

-> frontend_design

## 通信フロー

### 認証フロー

1. ユーザーがログインフォームに認証情報を入力
2. React SPA が API サーバーの/api/v1/auth/sign_in に POST リクエスト
3. サーバーが認証トークンを発行し、レスポンスヘッダーに含めて返却
4. SPA がトークンを localStorage に保存
5. 以降の API リクエストにトークンを含める

### データ取得フロー

1. ユーザーが特定ページにアクセス
2. React Router がコンポーネントをマウント
3. useEffect フックで API リクエスト実行
4. Rails サーバーがデータをデータベースから取得
5. JSON レスポンスとして結果を返却
6. React コンポーネントが状態を更新し、UI をレンダリング

## デプロイ構成

### 開発環境

localhost:3000(Rails)
localhost:3001(Vite/React)

### 本番環境

あとで

## セキュリティ考慮事項

- JWT 認証によるステートレス認証
- HTTPS 通信の強制
- CSRF 対策（API トークン）
- 適切な CORS 設定
