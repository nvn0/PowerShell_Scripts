Get-EventLog security -after (Get-date -hour 0 -minute 0 -second 0) | 
    Where-Object {
        $_.eventid -eq 4624 -and 
        $_.Message -match 'logon type:\s+(10|3)\s' #$_.Message -match 'logon type:\s+(10|3|5|7)\s'
    } | Out-GridView

# OUTRO COMANDO: Get-WinEvent -LogName 'Security'

#$RDPAuths = Get-WinEvent -LogName 'Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational' -FilterXPath '<QueryList><Query Id="0"><Select>*[System[EventID=1149]]</Select></Query></QueryList>'
#[xml[]]$xml=$RDPAuths|Foreach{$_.ToXml()}
#$EventData = Foreach ($event in $xml.Event)
#{ New-Object PSObject -Property @{
#TimeCreated = (Get-Date ($event.System.TimeCreated.SystemTime) -Format 'yyyy-MM-dd hh:mm:ss K')
#User = $event.UserData.EventXML.Param1
#Domain = $event.UserData.EventXML.Param2
#Client = $event.UserData.EventXML.Param3
#}
#} $EventData | FT
