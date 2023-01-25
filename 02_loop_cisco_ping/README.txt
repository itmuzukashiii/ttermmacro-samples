#--- 実行手順

1) Excel から 01_IPアドレス.txt にIPアドレスリストを貼り付ける

  ・1列目のみIPアドレスとして使用
　・# やタブから始まる行はスキップ

2) ping を実行したい (=ソースとなる) Cisco 機器に TeraTerm ログインし，enable しておく

3) TeraTerm メニューの "Control" → "Macro" から 03_loop_cisco_ping.ttl を読み込む

  ・ping_<日時>.log に結果が出力される

4) 04_format_ping_result.bat に ping_<日時>.log をドラッグ&ドロップする

  ・ping_<日時>.log.txt に整形済みテキストが出力される