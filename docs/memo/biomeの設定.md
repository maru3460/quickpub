# biome の設定

## vscode との連携

### バイナリが認識されない

wsl なのかワークスペースなのか原因はわからないが、biome のバイナリ?が認識されない

解決策
ワークスペースの settings.json で

```json
{
  "biome.lsp.bin": "ここは適当に/quickpub/frontend/node_modules/.bin/biome"
}
```

とする

### biome.json が認識されない

ドキュメントを見る限り、プロジェクトのルートに置かないと認識されないっぽい -> いや、ルートに置くのが正しいっぽい
ルートに置いても今度は package.json が認識されず(?)、警告が出る

解決策
なさそう(https://github.com/biomejs/biome/issues/2010)
[v2 で biome.json のパスを指定できるようになるっぽい](https://biomejs.dev/reference/vscode/#biomeconfigurationpath)ので v2 を待つとか？

## ルール

### linter

これ入れとかないと className を class にされる

```json
"suspicious": {
  "noReactSpecificProps": "off"
}
```
