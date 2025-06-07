## コマンド

### `update cline`

docs/cline/_.md をもとに、.clinerules を更新する。
ただし、`README.md`と`_\*.md`は除外する。
更新の手順

- `.clinerules`の内容を消す
- `docs/cline/`配下のファイルを走査し、`README.md`と`_\*.md`を除外して、残りのファイルの内容を`.clinerules`にコピペする。
- `docs/cline/`と`.clinerules`を commit する。(コミットメッセージは`update .clinerules`)
