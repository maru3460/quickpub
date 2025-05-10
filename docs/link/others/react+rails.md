君たちは React をどうやって Ruby on Rails に載せるべきか？

https://zenn.dev/naofumik/articles/f2c979acb24910

Ruby on Rails で React を使う方法

ポイント 1: 著者が開発した「react_router_rails_spa」という Gem を使うと、数行のコマンドでモダンな SPA（シングルページアプリケーション）を Ruby on Rails に簡単に統合できる。
ポイント 2: Create React App は 2025 年 2 月に非推奨となり、代わりに SPA フレームワークの使用が推奨されている。
ポイント 3: Vite の開発用サーバーを使うことで、Hot Module Replacement(HMR)などの開発効率を上げる機能が利用可能だが、開発環境と本番環境でポート番号が異なるというデメリットもある。
ポイント 4: このデメリットを解消するためのプロキシ設定も含まれており、本番環境と同じように開発できる。

結論: 「react_router_rails_spa」Gem によって React と Ruby on Rails の統合が簡単になり、開発効率と本番環境の一貫性の両方を実現できる。
