# biome の設定

## vscode との連携

問題
wsl なのかワークスペースなのか原因はわからないが、biome のバイナリ?が認識されない

解決策
ワークスペースの settings.json で

```json
{
  "biome.lsp.bin": "ここは適当に/quickpub/frontend/node_modules/.bin/biome"
}
```

とする

## ルール

### linter

これ入れとかないと className を class にされる

```json
"suspicious": {
  "noReactSpecificProps": "off"
}
```
