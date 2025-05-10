# docs

## docs について

quickpub に関するドキュメント置き場

## ディレクトリ構成と概要

### api

api ドキュメント
気が向いたら Swagger を使ってみる

### cline

.clinerules 用プロンプト集

### design

### development

### history

打ったコマンドとかの記録

### link

リンク集

### memo

メモ

### security

manus に書いてもらったセキュリティのハンドブック的なもの
quickpub と関係はない

- **`design/`**: 設計関連ドキュメント

  - `design_document.md`: (ユーザー様提供) プロジェクト全体の機能要件、システム構成、画面設計などが記載された基本設計書です。機能実装の際は必ず参照してください。

- **`development/`**: 開発ガイドライン、ルール、手順など

  - `development_guide_revised.md`: 本プロジェクトの開発全体の進め方、AI ペアプログラマーとの連携方法、コンテキスト節約のためのドキュメント手法などを記載した総合ガイドです。
  - `clinerules_proposal_revised.md`: コーディング規約 (RuboCop, Biome)、コミットメッセージ規約、ブランチ戦略、テスト方針 (RSpec, Vitest)、ドキュメンテーションルールなどを定めたものです。
  - `file_structure_proposal_revised.md`: Rails および React のディレクトリ構造、主要ファイルの役割、`docs/` ディレクトリ自体の構成について説明しています。
  - `environment_setup.md`: ローカル開発環境の構築手順（OS 別、必要なソフトウェア、プロジェクトセットアップ手順など）を詳細に記述しています。

## 使い方

何か思ったらとりあえず memo に書いておく
commit や PR 作成ごとにドキュメントを確認し、最新のものに更新していく
ファイル名は基本英語
ただ、調べる手間がかかるなら日本語
