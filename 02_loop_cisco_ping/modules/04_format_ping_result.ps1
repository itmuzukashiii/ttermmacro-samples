Param(
    [string] $pingLog
)

#--- $pingLog �����݂��Ȃ���ΏI��
if (-Not [System.IO.File]::Exists($pingLog)) {
    Write-Host "�t�@�C�������݂��܂���: $pingLog"
    Exit
}

#--- ���[�v�p�ꎞ�ϐ�
[string] $date   = ''
[string] $time   = ''
[string] $ip     = ''
[string] $result = ''
[string] $successRate  = ''
[string] $rtt    = ''

#--- �o�̓o�b�t�@�Ƃ��ă��X�g������
$buffer = [System.Collections.Generic.List[string]]::new()
#--- �w�b�_�ǉ�
$buffer.Add( (@('#����', 'IP�A�h���X', 'PING����', '������', 'RTT') -join "`t") )

Get-Content $pingLog | ForEach-Object {

    #--- �������s�R�[�h�폜
    [string] $line = ($_ -replace '[`r`n]*$', '')

    #--- "����" "IP�A�h���X" �擾

    #--- yyyy-MM-dd HH:mm:ss �`���Ńp�[�X
    if ($line -match '^\[(?<Date>[0-9\-]+) (?<Time>[0-9:]+)(?:[0-9\.]+)\] Sending.*ICMP Echos to (?<IPAddress>[^ ,]+)') {
    #--- yyyy-MM-dd HH:mm:ss.fff �`���Ńp�[�X
    # if ($line -match '^\[(?<Date>[0-9\-]+) (?<Time>[0-9\:\.]+)\] Sending.*ICMP Echos to (?<IPAddress>[^ ,]+)') {

        $date = $Matches.Date
        $time = $Matches.Time
        $ip   = $Matches.IPAddress
    }

    #--- "PING����" �擾
    if ($line -match '^\[[^\[\]]+\] (?<PingResult>[UHPNQM\.\!\?]+)$') {
        $result += $Matches.PingResult
    }

    #--- PING���v���(������, RTT) �擾 & �o�̓��R�[�h�쐬 & �ϐ�������
    if ($line -match '^\[[^\[\]]+\] (?<PingSuccessRate>Success rate[^,]*)(?:, (?<PingRtt>round\-trip.*))?$') {
        #--- "������" �擾
        $successRate = $Matches.PingSuccessRate
        #--- "RTT" �擾
        $rtt = $Matches.PingRtt

        #--- �o�̓��R�[�h
        $outRecord = (@(($date + ' ' + $time), $ip, $result, $successRate, $rtt) -Join "`t")
        # Write-Host $outRecord

        #--- �o�̓o�b�t�@�ɒǉ�
        $buffer.Add( $outRecord )

        #--- �ϐ�������
        ($date, $time, $ip, $result, $successRate, $rtt) = ('','','','','','')
    }
}

($buffer.ToArray() -Join "`r`n") | Out-File -Encoding Default -FilePath ($pingLog + '.txt')