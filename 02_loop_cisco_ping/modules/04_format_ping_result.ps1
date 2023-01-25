Param(
    [string] $pingLog
)

#--- $pingLog が存在しなければ終了
if (-Not [System.IO.File]::Exists($pingLog)) {
    Write-Host "ファイルが存在しません: $pingLog"
    Exit
}

#--- ループ用一時変数
[string] $date   = ''
[string] $time   = ''
[string] $ip     = ''
[string] $result = ''
[string] $successRate  = ''
[string] $rtt    = ''

#--- 出力バッファとしてリストを準備
$buffer = [System.Collections.Generic.List[string]]::new()
#--- ヘッダ追加
$buffer.Add( (@('#日時', 'IPアドレス', 'PING結果', '成功率', 'RTT') -join "`t") )

Get-Content $pingLog | ForEach-Object {

    #--- 末尾改行コード削除
    [string] $line = ($_ -replace '[`r`n]*$', '')

    #--- "日時" "IPアドレス" 取得

    #--- yyyy-MM-dd HH:mm:ss 形式でパース
    if ($line -match '^\[(?<Date>[0-9\-]+) (?<Time>[0-9:]+)(?:[0-9\.]+)\] Sending.*ICMP Echos to (?<IPAddress>[^ ,]+)') {
    #--- yyyy-MM-dd HH:mm:ss.fff 形式でパース
    # if ($line -match '^\[(?<Date>[0-9\-]+) (?<Time>[0-9\:\.]+)\] Sending.*ICMP Echos to (?<IPAddress>[^ ,]+)') {

        $date = $Matches.Date
        $time = $Matches.Time
        $ip   = $Matches.IPAddress
    }

    #--- "PING結果" 取得
    if ($line -match '^\[[^\[\]]+\] (?<PingResult>[UHPNQM\.\!\?]+)$') {
        $result += $Matches.PingResult
    }

    #--- PING統計情報(成功率, RTT) 取得 & 出力レコード作成 & 変数初期化
    if ($line -match '^\[[^\[\]]+\] (?<PingSuccessRate>Success rate[^,]*)(?:, (?<PingRtt>round\-trip.*))?$') {
        #--- "成功率" 取得
        $successRate = $Matches.PingSuccessRate
        #--- "RTT" 取得
        $rtt = $Matches.PingRtt

        #--- 出力レコード
        $outRecord = (@(($date + ' ' + $time), $ip, $result, $successRate, $rtt) -Join "`t")
        # Write-Host $outRecord

        #--- 出力バッファに追加
        $buffer.Add( $outRecord )

        #--- 変数初期化
        ($date, $time, $ip, $result, $successRate, $rtt) = ('','','','','','')
    }
}

($buffer.ToArray() -Join "`r`n") | Out-File -Encoding Default -FilePath ($pingLog + '.txt')