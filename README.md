# TeraTerm マクロ いろいろテストするリポジトリ

## 01_loop_cisco_traceroute

- IPv4 アドレス範囲に対して個々に traceroute するためのマクロ
- 結果を format_trace.sh に飲ませると TSV にできる

## 02_loop_cisco_ping

- テキスト各行の１列目に記載された IPv4 アドレスに対して ping 実行するためのマクロ

## 03_strsplit

- 文字列をセパレータで分割するサンプル
- 最大で9要素までしか分割できない点に注意
